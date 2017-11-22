#stat547 hw 08

library(shiny)
library(stringr)
library(ggplot2)
library(dplyr)

# read data
# this is data from pew research publicly available at http://www.pewforum.org/dataset/global-restrictions-on-religion-2007-2014/
relig <- read.csv("http://raw.githubusercontent.com/rishadhabib/STAT545-547-hw-habib-rishad/master/hw08-shinyapp/global-religious-restrictions.csv", stringsAsFactors = FALSE)

# Define UI for application that draws a plot
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Global Religious Restrictions survey"),
  
  # Sidebar with a slider input 
  sidebarLayout(
  	sidebarPanel(
  		h4("GRI: Government Restrictions Index based on 20 indicators of ways that national and local governments restrict religion, including through coercion and force."),
		br(),
		"0 to 10, from lowest to highest level of government restrictions",
		br(),
		br(),
  		# we have 2 inputs: yearInput and countryInput
  		sliderInput("yearInput", "Year", min = 2007, max = 2014,
  					value = c(2007, 2014), sep=""),
  		uiOutput("countryOutput")
  		),
  	mainPanel(
  		plotOutput("plot1"),
  		tableOutput("table1"))
  )))