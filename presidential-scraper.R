library(xml2)
library(rvest)
library(dplyr)
library(splitstackshape)
library(data.table)

scrapeTable <- function(scrapeYear) {
    pagebase <- "http://www.presidency.ucsb.edu/showelection.php?year="
    page <- read_html(paste0(pagebase, as.character(scrapeYear)))
    
    
    
    parseTable <- page %>%
        html_nodes(xpath = "/html/body/table/tr[2]/td/table/tr/td[2]/table/tr[2]/td/center/table/tr[position() >= 1 and not(position() > 61)]") %>%
        html_text %>% as.data.frame %>%
        cSplit(".", "\r", stripWhite = F)
    parseTable <-
        data.frame(lapply(parseTable, as.character), stringsAsFactors = FALSE)
    tableStart <- which(grepl("STATE", parseTable[, 1])) - 1
    tableEnd <- which(grepl("Wyoming", parseTable[, 1]))
    parseTable <- parseTable[tableStart:tableEnd,]
    
    
    findParty <-
        function(x) {
            # Accepts character vectors, returns if there's even 1 match of the party name in first 10 rows/columns. Unnecessarily long search but it doesn't hurt
            if (lapply(parseTable[1:10, 1:10], function(y)
                grepl("republican", tolower(y))) %>% lapply(any) %>% as.logical %>% any)
                return("Republican")
            if (lapply(parseTable[1:10, 1:10], function(y)
                grepl("democrat", tolower(y))) %>% lapply(any) %>% as.logical %>% any)
                return("Democrat")
            else
                return("Other") # Not really necessary but we'll keep it
        }
    
    extractPercents <- function(x) {
        return(gsub("%", "", x) %>% as.numeric)
    }
    
    
    prettyTable <- parseTable %>% select(1, 2, 4, 7)
    prettyTable <-
        prettyTable[-c(1:which(grepl("Alabama", parseTable[, 1])) - 1), ] #%>%
    # mutate(p1 = lapply(prettyTable[,3], extractPercents),
    #        p2 = lapply(prettyTable[,4], extractPercents)) %>%
    # select(1,2,p1,p2)
    
    # Because the website has inconsistent design practices,
    # we can't just hard-link whether the Democrats or Republicans come first.
    # Instead, we'll comb through the first row of parseTable to determine the order
    for (i in 1:length(parseTable[1,])) {
        if (findParty(parseTable) != "Other")
            break
    }
    firstCol <- findParty(parseTable[1, i] %>% as.character)
    secondCol <-
        ifelse(
            firstCol == "Democrat",
            "Republican",
            ifelse(firstCol == "Republican", "Democrat", "Other")
        )
    remove(i)
    
    
    
    names(prettyTable) <-
        #### FIX!!! Make it dynamic so the column doesn't matter. Read first row and see which party comes first.
        c("State",
          "Votes",
          firstCol,
          secondCol)
    prettyTable <-
        prettyTable %>% mutate(Year = scrapeYear) %>% select(Year, State, Votes, Democrat, Republican) %>%
        as.data.table() %>% apply(2, function(x)
            gsub("[%\n\t\r,]", "", x))
    prettyTable[, c(1, 3:5)] <-
        apply(prettyTable[, c(1, 3:5)], 2, as.numeric) # Just in case we weren't sure enough that we have just the numbers
    return(prettyTable)
}

yearList <-
    seq(2012, 1960,-4) # Alaska statehood in 1959. DC got electoral vote in 1961. The sixth party system was from 1969 to now.

fullTable <- NULL
for (i in seq_along(yearList)) {
    fullTable[[i]] <- scrapeTable(yearList[i]) %>% as.data.table
}
fullTable <- rbindlist(fullTable)

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
dir.create(file.path("./data"), showWarnings = FALSE)


write.table(
    fullTable,
    "./data/electionData.tsv",
    row.names = F,
    quote = F,
    sep = "\t"
)
saveRDS(fullTable, file="./data/fullTable.RDS")
