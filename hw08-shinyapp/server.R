#
# loading libraries

library(shiny)
library(ggplot2)
library(dplyr)
library(shinythemes)

# read data
# this is data from pew research publicly available at http://www.pewforum.org/dataset/global-restrictions-on-religion-2007-2014/

relig <- read.csv("global-religious-restrictions.csv", stringsAsFactors = FALSE)

# Define server logic required to draw the plot

shinyServer(function(input, output) {
	
	# selecting the countries using renderUI
	output$countryOutput <- renderUI({
		selectInput("countryInput", "Country",
					sort(unique(relig$Country)),
					selected = "Canada")
	})
	
	output$country2Output <- renderUI({
		selectInput("country2Input", "Country2",
					sort(unique(relig$Country)),
					selected = "Bangladesh")
	})
	
	# creating the filter based on input
	filtered <- reactive({
		if (is.null(input$countryInput)) {
			return(NULL)
		}
		relig %>%
			filter(Question_Year >= input$yearInput[1],
				   Question_Year <= input$yearInput[2],
				   Country %in% c(input$countryInput, input$country2Input)
			)
	})

	# plotting the data for one country
	output$plot1 <- renderPlot({
		if (is.null(filtered())) {
			return()
		}
		
		# filtered %>%
		# 	group_by(Country) %>%
			ggplot(filtered()) +
			geom_point(aes(y=GRI, x=Question_Year, group = Country), size = 5, colour = "blue") + 
			geom_line(aes(y=GRI, x=Question_Year, group = Country), colour="red") +
			scale_y_continuous(limits =c(0,10)) +			# adding max and min limits for the y axis for easier comparison
			theme_minimal()
	})
	
	# creating the output table
	output$table1 <- renderTable({
		filtered()
	})
})
