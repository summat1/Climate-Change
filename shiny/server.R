# Server
library(shiny)
library(tidyverse)
library(plotly)

data <- read_csv("owid-co2-data.csv")

data <- data %>% filter(year > 1950)

intro_md <- 
"### penis
###### penis"

caption_md <-
"hello"

server <- function(input, output) {
  output$chart <- renderPlotly({
    dataset <- data %>% filter(data %in% input$countries_selected)
    plot <- ggplot(data = dataset, mapping = aes(x = year, 
                                               y = input$variable_selected, 
                                               color = country)) +
      geom_line() +
      labs(x = "Year",
         y = input$variable_selected,
         title = paste0(input$variable_selected," over time"))
    return(plot)
  })
  
  output$introduction <- renderUI({
    HTML(markdown::markdownToHTML(text = intro_md, fragment.only = TRUE))
  })
  
  output$chart_caption <- renderUI({
    HTML(markdown::markdownToHTML(text = caption_md, fragment.only = TRUE))
  })
}