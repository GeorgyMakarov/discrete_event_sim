library(shiny)
library(shinythemes)
rm(list = ls())
setwd("/home/georgy/Документы/GitHub/discrete_event_sim/")

source("test_module.R")
# source("plot_module.R")

ui = fluidPage(
    titlePanel("TestApp"),
    test_ui('template1'))

server = function(input, output, session){
    test_server('template1')
}

shinyApp(ui = ui, server = server)