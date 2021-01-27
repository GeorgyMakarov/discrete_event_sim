# Define categories for process time slider input
proc_name = c("Low", "Low-medium", "Medium", "Medium-high", "High")
proc_time = c(2/20, 5/20, 20/20, 20/5, 20/2)
names(proc_time) = proc_name

# Define distribution parameters
rands   = 3    # random seed
ncycles = 1e6  # number of observations
multip  = 10   # multiplier which converts distribution to minutes


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
                     style = "color:#fff; background-color:#e95420 ")
    )
}


sawmoduleServer = function(id){
    moduleServer(
        id,
        function(input, output, session){
            observeEvent(input$run, {
                #Define choices
                pt_choice = reactive({input$proctime})
                tf_choice = reactive({input$tofail})
                rt_choice = reactive({input$reptime})
                du_choice = reactive({input$duration})
                
                #Compute s1 and s2 parameters for process time
                #Take into account the combination of s1 and s2 from pt choice
                # Compute process time distribution
                pt_chosen = proc_time[pt_choice]
                if (pt_chosen <= 1) {
                    proc_s1 = 20 * pt_chosen
                    proc_s2 = 20
                } else if (pt_chosen > 1) {
                    proc_s1 = 20
                    proc_s2 = 20 / pt_chosen
                }
                
                ptd = f.dgn(rands, ncycles, proc_s1, proc_s2, multip)
                
                # Temp solution -- update with code
                tfd = f.dgn(rands, ncycles, 10, 10, multip * 60)
                rtd = f.dgn(rands, ncycles, 30, 30, multip * 10)
                ojd = f.dgn(rands, ncycles, 10, 30, multip * 10)
                
                df = data.frame(ptd, tfd, rtd, ojd)
                return(df)
                
            })
        }
    )
}