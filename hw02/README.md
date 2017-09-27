# STAT545-hw02-habib-rishad

This repo contains the 2nd homework submission for STAT 545A

## Contents:
- [HW 02 markdown file](hw02.md)
- [HW02 R markdown file](hw02.Rmd)
- [Readme file](README.md)

- Some figures I like
  + [Canada's life Expectancy, GDP and population growth](hw02_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-6-1.png)
  + [Life expectancy by population across continents](hw02_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-7-1.png)
  + [Comparing Bangladesh and Canada](hw02_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-1.png)
  + [Life Expectancy Density plot](hw02_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-5-1.png)


## Reporting my process

First I created a new repo for the rest of the homework assignments for the course. I copied the repo and created a version control project on Rstudio which I saved locally. I then created a new folder in the repo for hw02 and made a readme file within the hw02 folder which I pulled to the Rstudio project.

For this homework I first created the skeleton of the file with sections for each part of the assignment. I also created sections for content and reporting in the readme file. I realized my previous assignment was not as well formatted in terms of user friendliness or readability and  wanted to improve on that. The [R markdown cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf) was a quick easy way to check out how to format different things.

I then began filling out the sections and playing around with the code. I tried adding years as labels to one of the plots and had trouble getting them to fit into the plot area; I managed to fix that hjust and vjust inside the geom_text function.

I also tried using kable to make some nicer looking output tables and [this link](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html) was very helpful. It was quite easy to use once the packages were installed.

Lastly I wanted to name my plots to make linking them to the readme easier but I couldn't figure out how to do that.
