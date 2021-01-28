library(shiny)
library(shinydashboard)

moduleUI <- function(id){
  
  ns <- NS(id)
  sidebarPanel(
    actionButton(ns("action1"), label = "click")
  )
}

module <- function(input, output, session, tabsPanel, openTab){
  
  observeEvent(input$action1, {
    if(tabsPanel() == "one"){  # input$tabsPanel == "one"
      openTab("two")
    }else{                     # input$tabsPanel == "two"
      openTab("one")
    }
  })
  
  return(openTab)
}

ui <- fluidPage(
  h2("Currently open Tab:"),
  verbatimTextOutput("opentab"),
  navlistPanel(id = "tabsPanel",
               tabPanel("one", moduleUI("first")),
               tabPanel("two", moduleUI("second"))
  ))


server <- function(input, output, session){
  openTab <- reactiveVal()
  observe({ openTab(input$tabsPanel) }) # always write the currently open tab into openTab()
  
  # print the currently open tab
  output$opentab <- renderPrint({
    openTab()
  })
  
  openTab <- callModule(module,"first", reactive({ input$tabsPanel }), openTab)
  openTab <- callModule(module,"second", reactive({ input$tabsPanel }), openTab)
  
  observeEvent(openTab(), {
    updateTabItems(session, "tabsPanel", openTab())
  })
}

shinyApp(ui = ui, server = server)