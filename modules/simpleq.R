

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
                     style = "color:#fff; background-color:#e95420 "),
        br(),
        br(),
        actionButton(ns("clear"),
                     label = "Clear")
    )
}


simplemoduleServer = function(id){}