#setwd("/home/georgy/Документы/GitHub/discrete_event_sim/")
setwd("/home/daria/Documents/projects/discrete_event_sim/")
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
                         fluidRow(
                             column(6, plotOutput("process_t")),
                             column(6, plotOutput("tofail_t"))
                         ),
                         fluidRow(
                             column(6, plotOutput("repair_t")),
                             column(6, plotOutput("sawn_vol"))
                         )
                     )
                 )),
        tabPanel("About",
                 br())
    )
)


server = function(input, output, session) {
    mydata = sawmoduleServer("sawn")
}

shinyApp(ui, server)