simple_module_ui = function(id){
    ns = NS(id)
    fluidPage(
        sidebarLayout(
            sidebarPanel(
                sliderInput(ns("nurses"),
                            label = "Select number of nurses",
                            min   = 1,
                            max   = 5,
                            value = 2,
                            step  = 1),
                sliderInput(ns("doctors"),
                            label = "Select number of doctors",
                            min   = 1,
                            max   = 5,
                            value = 2,
                            step  = 1),
                sliderInput(ns("admins"),
                            label = "Select number of admins",
                            min   = 1,
                            max   = 5,
                            value = 2,
                            step  = 1),
                actionButton(ns("run"),
                             label = "Run",
                             style = "color:#fff; background-color:#e95420")
            ),
            mainPanel(
                fluidRow(
                    column(width = 6,
                           plotOutput(ns("plot1"))),
                    column(width = 6,
                           plotOutput(ns("plot2")))
                )
            )
        )
    )
}



simple_module_server = function(id){
    moduleServer(
        id,
        function(input, output, session){
            
            vals_df = eventReactive(input$run, {
                ## define choice of params
                nurse = reactive({input$nurses})
                doct  = reactive({input$doctors})
                admin = reactive({input$admins})
                
                ## 
                
                
                return(df)
            })
            
            
        }
    )
}