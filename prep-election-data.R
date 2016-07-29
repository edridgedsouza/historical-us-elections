# Read in the data from the scraper and prep it to a workable form

library(dplyr)
library(data.table)
library(reshape)

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)


fullTable <- readRDS("./data/fullTable.RDS")

workableTable <- fullTable %>% mutate( # Make sure everything is right data type
    Year = as.numeric(Year),
    Votes = as.numeric(Votes),
    Democrat = as.numeric(Democrat),
    Republican = as.numeric(Republican)
) %>%
    mutate(Other = 100 - (Democrat + Republican)) %>% # Account for third-party votes
    melt(id = c("Year", "State", "Votes")) %>% # Melt the table down so we can work with it
    dplyr::rename(Total = Votes, Party = variable, Percent = value) %>%
    mutate(Votes = round((Percent / 100) * Total), # Show us the total votes and the votes per party
           State = gsub("\\*", "", State)) %>% # Remove the occasional asterisk
    mutate(State = replace(State, State == "Dist. of Col.", "DC")) # Choosing to have these `mutate`s separate for separation of tasks

# Saving everything in binary form since the raw data is already in the TSV

saveRDS(workableTable, file="./data/workableTable.RDS")


