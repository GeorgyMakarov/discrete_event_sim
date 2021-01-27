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
    #mydata = sawmoduleServer("sawn")
    #print(mydata)
    xp = rnorm(1e3, 100, 10)
    ep = rnorm(1e3, 10, 8)
    output$process_t = renderPlot({
        plot(x     = xp,
             y     = 20 + 0.5 * xp + ep,
             col   = "lightgreen",
             frame = F,
             pch   = 19)
        points(x   = xp,
               y   = 20 + 0.5 * xp + ep,
               col = "black",
               pch = 21)
    })
    output$tofail_t  = renderPlot({
            plot(x     = 1:1000,
                 y     = 20 + 0.2 * xp + ep * 2,
                 col   = "lightgreen",
                 frame = F,
                 pch   = 19)
            points(x   = 1:1000,
                   y   = 20 + 0.2 * xp + ep * 2,
                   col = "black",
                   pch = 21)
    })
    output$repair_t  = renderPlot({
        plot(x     = xp,
             y     = log(xp),
             col   = "lightgreen",
             frame = F,
             pch   = 19)
        points(x   = xp,
               y   = log(xp),
               col = "black",
               pch = 21)
    })
    output$sawn_vol  = renderPlot({
        plot(x     = xp,
             y     = log(xp),
             col   = "grey",
             frame = F,
             pch   = 19)
        points(x   = xp,
               y   = log(xp),
               col = "black",
               pch = 21)
    })
}

shinyApp(ui, server)