# Initial clustering analysis

library(dplyr)
library(magrittr)
library(reshape)
library(data.table)


this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

workableTable <- readRDS("./data/workableTable.RDS") %>% as.data.frame

data <- workableTable %>% select(Year, State, Party, Percent) %>% 
    reshape(idvar=c("State","Party"), timevar=c("Year"), direction="wide")
names(data) <- gsub("Percent\\.","",names(data))
data[is.na(data)] <- 0
# Data ready for clustering


# Fix this
#distMatrix <- data %>% group_by(Party) %>% dist()
