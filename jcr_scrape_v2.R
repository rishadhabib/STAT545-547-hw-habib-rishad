# hw 10 Data Scraping

# For this assignment I wanted to scrape the Journal of Consumer Research website. 
# This is one of the top journals in my field & abstracts are available online.

# loading libraries

library(tidyverse)
library(magrittr)
library(purrr)
library(stringr)
library(glue)

library(xml2)
library(rvest)


# set link
# this is set as a dynamic link so that all issues from a volume can be obtained

link <- function(volume = 43, issue = 1){

	# get all combinations of the end of the link
	link_end <- apply(expand.grid(volume, issue), 1, paste, collapse="/")
	
	# glue them all to the first bit
	lapply(link_end, function(link_end) 
		glue("https://academic.oup.com/jcr/issue/{link_end}"))
}	

# test it out
volume <- 43
issue <- 1
article_link <- as.character(link(volume, issue))


article_title <- read_html(as.character(article_link))
# page_title %>% View()


article_title <- article_link %>% 
				lapply(read_html) %>%
	html_nodes(css = ".customLink.item-title a") %>%    # use .title for the class = title
	html_attr("href")  

article_title <- article_link %>% 
	map(read_html) %>%
	map(html_node, ".customLink.item-title a") %>%    # use .title for the class = title
	map_chr(html_text)

View(article_title)
	
article_title %>%
  html_nodes(css = ".customLink.item-title a") %>%    # use .title for the class = title
  html_attr("href")                         # if we want the href part


# we will want to read the link to the main article to get the abstract as well as the title, author names, citation, 

jcr <- data_frame(volume = volume,
				  issue = issue,
	
                  # let's get the title of the article 
                  title = article_title %>%
                    html_nodes(css = ".customLink.item-title") %>%    # use .title for the class = title
                    html_text(trim = TRUE),  
                  
                  # and the citation
                  citation = article_title %>%
                    html_nodes(css = ".ww-citation-primary") %>%    # use .title for the class = title
                    html_text(), 
                  
                  # and the link to the main article where we can find the abstract
                  article = article_title %>%
                    html_nodes(css = ".customLink.item-title a") %>%
                    html_attr("href"), 
                  
                  link = glue("https://academic.oup.com{article}"))

jcr$title[1]
jcr$link
jcr$abstract[8]

# https://academic.oup.com/jcr/article/44/3/477/2939534


# Function to extract the abstract from the link

# now we write a function to do this
get_abstract <- function(link){         # this link points to a link that is extracted
    read_html(link) %>%                      
    html_nodes(css = ".abstract") %>%
    html_text()
}

# check to see if function works with a sample article link
get_abstract("https://academic.oup.com/jcr/article/44/3/477/2939534")

# add to our jcr dataframe
jcr %<>%
  mutate(abstract = sapply(jcr$link, get_abstract))


# add the author names
authors <- article_title %>%
    html_nodes(css = ".al-authors-list") %>%    # use .title for the class = title
    html_text(trim = TRUE)

authors <- c(authors, rep("NA", nrow(jcr)-length(authors)))

jcr %<>%
  mutate(authors = authors, abstract = as.character(abstract))

View(jcr)


# write to file
write.csv(as.data.frame(jcr), file = paste0("jcr", volume, issue, ".csv"), row.names = FALSE)
 