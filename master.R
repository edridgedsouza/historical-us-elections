# Master analysis file
# US Historical election data
# Edridge D'Souza, 7/27/16

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

files <- c("presidential-scraper.R")

lapply(files, function(x) source(x,local=TRUE))

