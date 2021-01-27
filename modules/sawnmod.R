# Define categories for process time slider input
proc_name = c("Low", "Low-medium", "Medium", "Medium-high", "High")
proc_time = c(2/20, 5/20, 20/20, 20/5, 20/2)
names(proc_time) = proc_name


sawmoduleUI = function(id){
    ns = NS(id)
    tagList(
        sliderTextInput(ns("proctime"),
                        "Process time",
                        choices = names(proc_time),
                        selected = names(proc_time)[3]),
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