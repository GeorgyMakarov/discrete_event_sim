# setwd("/home/georgy/Документы/GitHub/discrete_event_sim/")
# setwd("/home/daria/Documents/projects/discrete_event_sim/")
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(waiter))
suppressPackageStartupMessages(library(shinythemes))
suppressPackageStartupMessages(library(shinyWidgets))
suppressPackageStartupMessages(library(simmer))
suppressPackageStartupMessages(library(magrittr))


rm(list = ls())
source("distr_generator.R")
source("traj_functions.R")
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
                 br(),
                 column(width = 3),
                 column(width = 6,
                        h4("What does this app?"),
                        p("This project shows how you can use discrete event
                          simulation to help taking management decisions. There
                          are two tabs in the app. Simple queue tab shows a 
                          simple example of queue management in the hospital
                          by changing the number of admins, nurses and doctors.
                          Sawmill sim tab simulates the work of a sawmill --
                          the result of the simulation is a number of logs
                          sawn during the certain period."),
                        br(),
                        p("Source code is available at ", 
                          tags$a(
                              href = 
                                  "https://github.com/GeorgyMakarov/discrete_event_sim", 
                              "GitHub")),
                        br(),
                        p("Email: georgy.v.makarov@gmail.com"),
                        br(),
                        p("Linkedin", 
                          tags$a(
                              href = 
                                  "https://www.linkedin.com/in/georgy-makarov-11436b42/", 
                              "Georgy Makarov"))),
                 column(width = 3))
    )

)


server = function(input, output, session){
    simple_module_server("simple")
    saw_module_server("sawmill")
}

shinyApp(ui = ui, server = server)