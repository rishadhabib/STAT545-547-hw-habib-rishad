hw10\_jcrscrape
================
RH
December 7, 2017

#### set link

##### this is set as a dynamic link so that all issues from a volume can be obtained

``` r
link <- function(volume = 44, issue = 1){
    
    # get all combinations of the end of the link
    link_end <- paste(volume, issue, sep="/")
    
    # glue them all to the first bit
    lapply(link_end, function(link_end) 
        glue("https://academic.oup.com/jcr/issue/{link_end}"))
}   

# test it out
volume <- 43
issue <- 3
article_link <- as.character(link(volume, issue))
article_link
```

    ## [1] "https://academic.oup.com/jcr/issue/43/3"

#### Now we can read in data from that link

``` r
article_title <- read_html(article_link)
```

#### Creating the dataframe

``` r
jcr <- data_frame(volume = volume,
                  issue = issue, 
                  
                  # let's get the title of the article 
                  title = article_title %>%
                    html_nodes(css = ".customLink.item-title") %>%    
                    html_text(trim = TRUE),  
                  
                  # and the citation
                  citation = article_title %>%
                    html_nodes(css = ".ww-citation-primary") %>%   
                    html_text(), 
                  
                  # and the link to the main article where we can find the abstract
                  article = article_title %>%
                    html_nodes(css = ".customLink.item-title a") %>%
                    html_attr("href"), 
                  
                  link = glue("https://academic.oup.com{article}"))
```

#### View the dataframe

``` r
View(jcr)
```

#### Function to extract the abstract from the link

``` r
get_abstract <- function(link){         # this link points to a link that is extracted
    
    read_html(link) %>%                       # this is the link
        html_nodes(css = ".abstract") %>%
        html_text()
}

# check to see if function works with a sample article link
get_abstract("https://academic.oup.com/jcr/article/44/3/477/2939534")
```

    ## [1] "Political ideology plays a pivotal role in shaping individuals’ attitudes, opinions, and behaviors. However, apart from a handful of studies, little is known about how consumers’ political ideology affects their marketplace behavior. The authors used three large consumer complaint databases from the Consumer Financial Protection Bureau, National Highway Traffic Safety Administration, and Federal Communications Commission in conjunction with a county-level indicator of political ideology (the 2012<U+2009>US presidential election results) to demonstrate that conservative consumers are not only less likely than liberal consumers to report complaints but also less likely to dispute complaint resolutions. A survey also sheds light on the relationship between political ideology and complaint/dispute behavior. Due to stronger motivations to engage in “system justification,” conservative (as opposed to liberal) consumers are less likely to complain or dispute. The present research offers a useful means of identifying those consumers most and least likely to complain and dispute, given that political ideology is more observable than most psychological factors and more stable than most situational factors. Furthermore, this research and its theoretical framework open opportunities for future research examining the influence of political ideology on other marketplace behaviors."

#### add to our jcr dataframe

``` r
jcr %<>%
    mutate(abstract = sapply(jcr$link, get_abstract))
```

#### add the author names

``` r
authors <- article_title %>%
    html_nodes(css = ".al-authors-list") %>%    # use .title for the class = title
    html_text(trim = TRUE)

authors <- c(authors, rep("NA", nrow(jcr)-length(authors)))

jcr %<>%
    mutate(authors = authors, abstract = as.character(abstract))
```

#### View our final dataframe

``` r
View(jcr)
```

#### Lastly let's write the file with the volume and issue in the csv file

``` r
write.csv(as.data.frame(jcr), file = paste0("jcr", volume, issue, ".csv"), row.names = FALSE)
```

#### Sentiment analysis

``` r
afinn <- get_sentiments(("afinn"))
jcr %>%
    unnest_tokens (word, abstract) %>%
    anti_join(stop_words, by = "word") %>% #remove dull words
    inner_join(afinn, by = "word") %>% #stitch scores
    group_by(title) %>% #and for each article title
    summarise(Length = n(), #do the math
              Score = sum(score)/Length) %>%
    arrange(-Score) %>%
    kable()
```

| title                                                                                                     |  Length|      Score|
|:----------------------------------------------------------------------------------------------------------|-------:|----------:|
| Men and the Middle: Gender Differences in Dyadic Compromise Effects                                       |       2|   2.000000|
| Slowing Down in the Good Old Days: The Effect of Nostalgia on Consumer Patience                           |       4|   1.750000|
| Altering Speed of Locomotion                                                                              |       9|   1.666667|
| Hedonic Escalation: When Food Just Tastes Better and Better                                               |       6|   1.500000|
| When Brand Logos Describe the Environment: Design Instability and the Utility of Safety-Oriented Products |      10|   0.400000|
| Why Focusing on the Similarity of Substitutes Leaves a Lot to Be Desired                                  |       4|  -0.250000|
| Repayment Concentration and Consumer Motivation to Get Out of Debt                                        |      18|  -0.500000|

So we get the most positive article about compromise and the most negative article about debt.
