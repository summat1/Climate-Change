# Server
library(shiny)
library(tidyverse)
library(plotly)

data <- read_csv("owid-co2-data.csv")

# Only working with recent data
data <- data %>% filter(year > 1950)


# Calculating summary statistics
max_co2_capita <- data %>% filter(year == 2021) %>% 
  filter(co2_per_capita == max(co2_per_capita, na.rm = T)) %>% 
  pull(country)

max_co2_capita_amount <- round(data %>% filter(year == 2021) %>% 
  filter(co2_per_capita == max(co2_per_capita, na.rm = T)) %>% 
  pull(co2_per_capita))

total_co2 <- round(data %>% filter(year == 2021) %>% 
  summarise(total_co2 = sum(co2, na.rm = T)) %>% 
  pull(total_co2))

max_energy_capita <- data %>% filter(year == 2021) %>% 
  filter(energy_per_capita == max(energy_per_capita, na.rm = T)) %>% 
  pull(country)

max_energy_capita_amount <- round(data %>% filter(year == 2021) %>% 
  filter(energy_per_capita == max(energy_per_capita, na.rm = T)) %>% 
  pull(energy_per_capita))


max_share_continent <- data %>% filter(year == 2021) %>% 
  filter(country != "World") %>% 
  filter(country != "High-income countries") %>% 
  filter(share_global_cumulative_co2 == max(share_global_cumulative_co2, na.rm = T)) %>% 
  pull(country)

max_share_amount <- round(data %>% filter(year == 2021) %>% 
  filter(country != "World") %>% 
  filter(country != "High-income countries") %>% 
  filter(share_global_cumulative_co2 == max(share_global_cumulative_co2, na.rm = T)) %>% 
  pull(share_global_cumulative_co2))

# Markdown format for chart caption
caption_md <- "Certain countries contribute more to emissions than others. 
This interactive visualizations allows users to explore some of the most
relevant countries trends in emissions and various other variables
over the past 70 years. One interesting trend to note is that **China seems to have
the steepest rate of increase of CO2 emissions** in recent years. Many other countries have 
begun to slow their emissions. **UAE and US** have the highest CO2 emissions 
per capita. This makes sense as these are **wealthier countries** that use more 
fuel per person. China and Russia have the highest CO2 per GDP, indicating 
they are highly **dependent on carbon emissions for their economy.**"

# Markdown format for introduction
intro_md <- paste0(
"## Climate Change is one of the most significant issues facing the world today.

To understand climate change in the world, we can analyze a dataset from _Our World in Data_. 
This dataset was collected from various energy data sources and contains info on 
different countries' emissions and other key metrics related to climate change over time. 

In the world in 2021, ", formatC(total_co2, format = "d", big.mark = ","), " **million** tonnes of CO2 were emitted. Out of
all continents, ", max_share_continent, " contributes the most to CO2 emissions, 
making up ", max_share_amount, "% of emissions. One country also stands out as 
that with the **most pollution per capita**, ", max_co2_capita, ". This country emitted ",
max_co2_capita_amount, " tonnes per person of CO2 in 2021. Furthermore, ", max_energy_capita, 
" also emits the most energy per capita. In 2021, this country emitted ", formatC(max_energy_capita_amount, format = "d", big.mark = ","), 
" kilowatt-hours of energy per person. It is important to keep in mind the emissions 
per person as well as total, as larger countries may be unnecessarily targeted when looking at totals.
Hopefully, climate change is tackled where emissions are the most unnecessary, and we 
can move towards **a more sustainable planet.**")

# Server function for chart and markdown rendering
server <- function(input, output) {
  # Creating interactive chart
  output$chart <- renderPlotly({
    dataset <- data %>% filter(country %in% input$countries_selected)
    plot <- ggplot(data = dataset, mapping = aes(x = year, 
                                                 y = !!as.symbol(input$variable_selected), 
                                                 color = country)) +
      geom_line() +
      labs(title = str_to_title(paste0(input$variable_selected, " in various countries over time")),
           x = "Year",
           y = str_to_title(str_replace_all(input$variable_selected, "\\.", " "))
           )
    return(plot)
  })
  
  # Output chart caption
  output$chart_caption <- renderUI({
    HTML(markdown::markdownToHTML(text = caption_md, fragment.only = TRUE))
  })
  
  # Output intro
  output$introduction <- renderUI({
    HTML(markdown::markdownToHTML(text = intro_md, fragment.only = TRUE))
  })
}
