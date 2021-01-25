setwd("/home/georgy/Документы/GitHub/discrete_event_sim/")
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(waiter))
suppressPackageStartupMessages(library(shinythemes))
suppressPackageStartupMessages(library(shinyWidgets))


rm(list = ls())
source("distr_generator.R")
source("./modules/simpleq.R")
source("./modules/sawnmod.R")


ui = fluidPage(
    theme = shinytheme("united"),
    navbarPage(
        "Discrete event simulator",
        tabPanel("Simple queue",
                 br(),
                 sidebarLayout(
                     sidebarPanel(
                         simplemoduleUI("simpleq")
                     ),
                     mainPanel(
                         plotOutput("simpleqplot")
                     )
                 )),
        tabPanel("Sawmill sim",
                 br(),
                 sidebarLayout(
                     sidebarPanel(
                         sawmoduleUI("sawn")
                     ),
                     mainPanel(
                         plotOutput("sawnplot")
                     )
                 )),
        tabPanel("About",
                 br())
    )
)


server = function(input, output, session) {}

shinyApp(ui, server)