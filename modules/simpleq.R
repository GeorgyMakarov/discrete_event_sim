

simplemoduleUI = function(id){
    ns = NS(id)
    tagList(
        sliderInput(ns("nurse"),
                    "Number of nurses",
                    min   = 1,
                    max   = 5,
                    value = 2,
                    step  = 1),
        sliderInput(ns("doctor"),
                    "Number of doctors",
                    min   = 1,
                    max   = 5,
                    value = 2,
                    step  = 1),
        sliderInput(ns("admin"),
                    "Number of admins",
                    min   = 1,
                    max   = 5,
                    value = 2,
                    step  = 1),
        actionButton(ns("run"),
                     label = "Run",
                     style = "color:#fff; background-color:#e95420 ")
    )
}


simplemoduleServer = function(id){
    moduleServer(
        id,
        function(input, output, session){
            observeEvent(input$run,{
                nurses  = reactive({input$nurse})
                doctors = reactove({input$doctor})
                admins  = reactive({input$admin})
            })
        }
    )
}