#
# loading libraries

library(shiny)
library(ggplot2)
library(dplyr)

# Define server logic required to draw the plot

shinyServer(function(input, output) {
	
	# selecting the countries using renderUI
	output$countryOutput <- renderUI({
		selectInput("countryInput", "Country",
					sort(unique(relig$Country)),
					selected = "Canada")
	})
	
	# creating the filter based on input
	filtered <- reactive({
		if (is.null(input$countryInput)) {
			return(NULL)
		}
		relig %>%
			filter(Question_Year >= input$yearInput[1],
				   Question_Year <= input$yearInput[2],
				   Country == input$countryInput
			)
	})

	# plotting the data for one country
	output$plot1 <- renderPlot({
		ggplot(filtered(), aes(y=GRI, x=Question_Year)) +
			geom_point(size = 5, colour = "red") + 
			geom_line(colour="red") +
			scale_y_continuous(limits =c(0,10)) +			# adding max and min limits for the y axis for easier comparisons
			theme_minimal()
	})
	
	# creating the output table
	output$table1 <- renderTable({
		filtered()
	})
})
