test_ui = function(id){
    ns = NS(id)
    fluidPage(
        sidebarLayout(
            sidebarPanel(sliderInput(ns("xvar"),
                                     label = "Choose X var",
                                     min   = 1,
                                     max   = 10,
                                     value = 5,
                                     step  = 1),
                         actionButton(ns("run"), "Run")),
            mainPanel(plotOutput(ns("plot1")))
        )
    )
}


test_server = function(id){
    moduleServer(
        id,
        function(input, output, session){
            
            random_vals = eventReactive(input$run, {
                xvar = reactive({input$xvar})
                d    = rnorm(1e+3, mean = 15, sd = xvar())
                return(d)
            })
            
            output$plot1 = renderPlot({
                plot(x = random_vals())
            })
        }
    )
}