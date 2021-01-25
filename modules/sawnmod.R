proc_time = c("Low", "Low-medium", "Medium", "Medium-high", "High")

sawmoduleUI = function(id){
    ns = NS(id)
    tagList(
        sliderTextInput(ns("proctime"),
                        "Process time",
                        choices = proc_time,
                        selected = proc_time[3]),
        # sliderInput(ns("proctime"),
        #             "Process time",
        #             min   = 1,
        #             max   = 100,
        #             value = 50,
        #             step  = 10,
        #             ticks = F),
        sliderInput(ns("tofail"),
                    "Time to failure",
                    min   = 1,
                    max   = 100,
                    value = 50,
                    step  = 10,
                    ticks = F),
        sliderInput(ns("reptime"),
                    "Repair time",
                    min   = 1,
                    max   = 100,
                    value = 50,
                    step  = 10,
                    ticks = F),
        sliderInput(ns("duration"),
                    "Sim horizon weeks",
                    min   = 1,
                    max   = 10,
                    value = 4,
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


sawmoduleServer = function(id){}