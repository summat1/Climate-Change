library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)

data <- read_csv("owid-co2-data.csv")
countries <- unique(data$country)
variables <- c("gdp", "co2")

home_panel <- tabPanel(
  title = "Introduction",
  titlePanel = "An Investigation into Climate Change",
  fluidPage(
    p(uiOutput('introduction'))
  )
)

chart_side_content <- sidebarPanel(
  selectInput(
    inputId = 'countries_selected',
    label = "Choose Countries to Show",
    selected = c("United States", "United Kingdom"),
    choice = countries,
    multiple = TRUE,
  ),
  selectInput(
    inputId = 'variable_selected',
    label = 'Choose Variable to Visualize',
    selected = "co2",
    choice = variables,
  ),
  p(uiOutput('chart_caption'))
)

chart_main_content <- mainPanel(plotlyOutput("chart"))


chart_panel <- tabPanel(
  title = "Graphical Analysis",
  titlePanel = "Visual Data Analysis of Climate Change Data",
  sidebarLayout(
    chart_side_content,
    chart_main_content
  )
)

ui <- navbarPage("Climate Change",
                 home_panel,
                 chart_panel,
                 theme = shinytheme("cosmo"))