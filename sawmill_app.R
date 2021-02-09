# setwd("/home/georgy/Документы/GitHub/discrete_event_sim/")
#setwd("/home/daria/Documents/projects/discrete_event_sim/")
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(waiter))
suppressPackageStartupMessages(library(shinythemes))
suppressPackageStartupMessages(library(shinyWidgets))
suppressPackageStartupMessages(library(simmer))
suppressPackageStartupMessages(library(magrittr))


rm(list = ls())
source("distr_generator.R")
source("./modules/simpleq.R")
source("./modules/sawnmod.R")


ui = fluidPage(
    use_waiter(),
    theme = shinytheme("united"),
    titlePanel("Discrete Event Simulation"),
    navbarPage(
        title = "Options",
        tabPanel("Simple queue",
                 br(),
                 simple_module_ui("simple")),
        tabPanel("Sawmill sim",
                 br(),
                 saw_module_ui("sawmill")),
        tabPanel("About",
                 br())
    )

)


server = function(input, output, session){
    simple_module_server("simple")
}

shinyApp(ui = ui, server = server)