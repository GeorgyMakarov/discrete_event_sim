# Define categories for process time slider input
proc_name = c("Low", "Low-medium", "Medium", "Medium-high", "High")
proc_time = c(2/20, 5/20, 20/20, 20/5, 20/2)
names(proc_time) = proc_name

# Define distribution parameters
rands   = 3    # random seed
ncycles = 1e6  # number of observations
multip  = 10   # multiplier which converts distribution to minutes

# Define base parameters for sliders
tf_base = 30
rt_base = 30


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
                # Define choices
                pt_choice = reactive({input$proctime})
                tf_choice = reactive({input$tofail})
                rt_choice = reactive({input$reptime})
                du_choice = reactive({input$duration})
                
                
                # Compute s1 and s2 parameters for process time
                # Take into account the combination of s1 and s2 from pt choice
                pt_chosen = proc_time[pt_choice()]
                if (pt_chosen <= 1) {
                    proc_s1 = 20 * pt_chosen
                    proc_s2 = 20
                } else if (pt_chosen > 1) {
                    proc_s1 = 20
                    proc_s2 = 20 / pt_chosen
                }
                
                
                # Compute process time distribution
                ptd = f.dgn(rands, ncycles, proc_s1, proc_s2, multip)
                
                
                # Compute time to fail s1 and s2 parameters
                # Compute time to fail distribution
                ## add 1 to s1 to avoid 0 values when tf_choice is low
                time_to_fail_s1 = round(1 + (tf_base * tf_choice() / 100), 0)
                ## use 103 percent which allows s2 to be positive at any choice
                ## at the same time it does not significantly affect the
                ## distribution
                time_to_fail_s2 = round(tf_base * (103 - tf_choice()) / 100, 0)
                tfd = f.dgn(rands, 
                            ncycles, 
                            time_to_fail_s1, 
                            time_to_fail_s2, 
                            multip * 60)
                
                
                # Compute repair time s1 and s2
                # Compute repair time distribution
                ## add 1 to s1 to avoid 0 values when tf_choice is low
                rt_s1 = round(1 + (rt_base * rt_choice() / 100), 0)
                ## use 103 percent which allows s2 to be positive at any choice
                ## at the same time it does not significantly affect the
                ## distribution
                rt_s2 = round(rt_base * (103 - rt_choice()) / 100, 0)
                rtd   = f.dgn(rands,
                              ncycles,
                              rt_s1,
                              rt_s2,
                              multip * 10)
                
                
                # Compute other jobs time -- not reactive
                # Make it close to normal distribution
                ojd = f.dgn(rands, ncycles, 30, 30, multip * 4)
                
                
                # Define environment parameters
                pt_mean = round(mean(ptd), 2)  # mean process time
                pt_sigm = round(sd(ptd), 2)    # standard deviation of process time
                
                tf_mean = round(mean(tfd), 2)  # mean time to failure
                tf_exp  = 1 / tf_mean          # mean time to failure for exponential distr
                
                rt_mean = round(mean(rtd), 2)  # mean repair time
                oj_mean = round(mean(ojd), 2)  # mean other job time
                
                n_saws  = 3                              # number of saws
                fc_dur  = du_choice() * 7 * 24 * 60      # sim duration in mins
                
                
                # Compute parameters density used in plots
                d_pt = density(ptd)
                d_tf = density(tfd)
                d_rt = density(rtd)
            })
        }
    )
}