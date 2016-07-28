# Historical Presidential Elections Analysis

After reading many FiveThirtyEight analysis of the 2016 election, I was interested in playing with the data from past elections. I scraped all of my data from [UCSB](http://www.presidency.ucsb.edu/showelection.php), and then performed various analyses on them. The project is still in progress, so it has room to evolve

## Getting Started

To run this project, simply `source` the file master.R

This will generate the output files and plots. To look at all of the analyses interactively, I will later include an RMarkdown file or notebook that puts them all in perspective.

### Prerequisities

There aren't very many packages required, but please make sure you have them and their dependencies installed. At the moment, if you don't have these, you can install them with 
```
install.packages(c("ggplot2", "dplyr", "magrittr", "reshape", "tidyr", "rvest", "data.table", "xml2", and "splitstackshape"), dependencies=T)
```

## Authors

* **Edridge D'Souza** - *Primary author*

## License

This project is licensed under the MIT License - see the [LICENSE.md](./LICENSE.md) file for details. I am not a lawyer; I would like to thank anyone whose libraries I have used for this project. If you use/fork my code for your own project, I just ask that you add a link to my repo in your acknowledgements.

## Acknowledgments

* Thank you to UCSB for providing the public data source for my scraper.