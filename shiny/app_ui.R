# UI
library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)

source("app_server.R")

# Countries to choose from
countries <- c("United States", "United Kingdom", "Japan", "China", "Russia",
               "India", "France", "Italy", "Israel", "United Arab Emirates", "Canada",
               "Australia", "Spain", "Greece", "Egypt", "Saudi Arabia")

# Variables to graph
variables <- c("co2", "gdp", "co2_growth_prct", "co2_per_capita", "co2_per_gdp",
               "co2_per_unit_energy", "energy_per_capita", "energy_per_gdp",
               "share_global_co2", "total_ghg")

# home panel using image and intro text
home_panel <- tabPanel(
  title = "Introduction",
  fluidPage(
    img("", src = "https://pharmaphorum.com/wp-content/uploads/2022/09/climate-change.jpg"),
    p(uiOutput("introduction"))
  )
)

# Chart sidebar
# for countries to choose and variable to graph
chart_side_content <- sidebarPanel(
  selectInput(
    inputId = 'countries_selected',
    label = "Choose Countries to Show",
    selected = c("United States", "United Kingdom", "China"),
    choice = countries,
    multiple = TRUE),
  
  selectInput(
    inputId = 'variable_selected',
    label = 'Choose Variable to Visualize',
    selected = "co2",
    choice = variables),
  
  p(uiOutput('chart_caption'))
)

# Chart itself
chart_main_content <- mainPanel(plotlyOutput("chart"))

# Organizing chart panel
chart_panel <- tabPanel(
  title = "Graphical Analysis",
  titlePanel = "Visual Data Analysis of Climate Change Data",
  sidebarLayout(
    chart_side_content,
    chart_main_content
  )
)

# ui 
ui <- navbarPage("Climate Change",
                 home_panel,
                 chart_panel,
                 theme = shinytheme("cosmo"))
