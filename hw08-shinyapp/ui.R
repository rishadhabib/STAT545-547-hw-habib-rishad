#stat547 hw 08

library(shiny)
library(stringr)
library(ggplot2)
library(dplyr)
library(shinythemes)


# Define UI for application that draws a plot
shinyUI(fluidPage(
			theme = shinytheme("lumen"),
  
  # Application title
  titlePanel("Global Religious Restrictions survey"),
  img(src = "http://www.pewresearch.org/wp-content/mu-plugins/pew-temp-refactor/assets/img/logos/desktop-header.png",
  	  width = "30%"),
  br(),
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
  		uiOutput("countryOutput"),
		uiOutput("country2Output")
  		),
  	mainPanel(
  		tabsetPanel(
  			tabPanel("Plot", 
  					 plotOutput("plot1")),
  			tabPanel("table", 
  					 tableOutput("table1"))
  			))
  )))