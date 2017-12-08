# hw10 Data Scraping

This repo contains the **10th** and last homework submission for STAT 547


## Contents:
- [HW 10 R script](jcr_scrape.R)
- [HW 10 markdown file](hw10_jcrscrape.md)
- [Readme file](README.md)




## Reporting my Process:

Like previous assignments I first created the homework folder, README file and R script where I created an outline for this homework assignment in my STAT 5457project file. This was a fun assignment and I chose a simple but hopefully useful website to scrape.

For this assignment I wanted to scrape the Journal of Consumer Research website. This is one of the top journals in my field & abstracts are available online. Scraping the data would make it easier for me to search through the abstracts for key terms and topics as well as see which authors published the most in my field. I was trying to make a function that would output all the abstracts and citations for a number of journal articles and managed to get the links all nice and ready using the following:

```{r}
link <- function(volume = 43, issue = 1){

	# get all combinations of the end of the link
	link_end <- apply(expand.grid(volume, issue), 1, paste, collapse="/")
	
	# glue them all to the first bit
	lapply(link_end, function(link_end) 
		glue("https://academic.oup.com/jcr/issue/{link_end}"))
}	

# test it out
volume <- 43:44
issue <- 1:6
article_link <- as.character(link(volume, issue))
article_link
```
However, the read_html and other functions would not work well with lists and I could not get it into a nice dataframe. So I settled for scraping just one issue of JCR. The classes on data scraping were very helpful in interpreting the html and writing the code.