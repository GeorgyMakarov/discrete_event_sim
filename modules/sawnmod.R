# Define categories for process time slider input
proc_name = c("Low", "Low-medium", "Medium", "Medium-high", "High")
proc_time = c(2/20, 5/20, 20/20, 20/5, 20/2)
names(proc_time) = proc_name


# Define distribution parameters
rands   = 3    # random seed
ncycles = 1e5  # number of observations
multip  = 10   # multiplier which converts distribution to minutes


# Define base parameters for sliders
tf_base = 30
rt_base = 30

waiting_screen = tagList(spin_ellipsis(),
                         h4("Loading in progress..."))


saw_module_ui = function(id){
  ns = NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        sliderTextInput(ns("proctime"),
                        "Select process time",
                        choices = names(proc_time),
                        selected = names(proc_time)[3]),
        sliderInput(ns("tofail"),
                    label = "Select time to failure",
                    min   = 0,
                    max   = 100,
                    value = 30,
                    step  = 10,
                    ticks = F),
        sliderInput(ns("reptime"),
                    label = "Select repair time",
                    min   = 0,
                    max   = 100,
                    value = 30,
                    step  = 10,
                    ticks = F),
        sliderInput(ns("dur"),
                    label = "Sim run duration in weeks",
                    min   = 1,
                    max   = 10,
                    value = 4,
                    step  = 1),
        actionButton(ns("run"),
                     label = "Run",
                     style = "color:#fff; background-color:#e95420")
      ),
      mainPanel(
        fluidRow(
          column(width = 6,
                 plotOutput(ns("plot1")),
                 plotOutput(ns("plot3"))),
          column(width = 6,
                 plotOutput(ns("plot2")),
                 plotOutput(ns("plot4")))
        )
      )
    )
  )
}

saw_module_server = function(id){
  moduleServer(
    id,
    function(input, output, session){
      
      vals_df = eventReactive(input$run, {
        
        #Define choices
        pt_choice = reactive({input$proctime})
        tf_choice = reactive({input$tofail})
        rt_choice = reactive({input$reptime})
        du_choice = reactive({input$dur})
        
        waiter_show(html = waiting_screen, color = "grey")
        
        pt_chosen = reactive({proc_time[pt_choice()]})
        if (pt_chosen() <= 1) {
          proc_s1 = 20 * pt_chosen()
          proc_s2 = 20
        } else if (pt_chosen() > 1) {
          proc_s1 = 20
          proc_s2 = 20 / pt_chosen()
        }
        
        tf_s1 = round(1 + (tf_base * tf_choice() / 100), 0)
        tf_s2 = round(tf_base * (103 - tf_choice()) / 100, 0)
        
        rt_s1 = round(1 + (rt_base * rt_choice() / 100), 0)
        rt_s2 = round(rt_base * (103 - rt_choice()) / 100, 0)
        
        # Compute distributions
        ptd = f.dgn(rands, ncycles, proc_s1, proc_s2, multip)
        tfd = f.dgn(rands, ncycles, tf_s1, tf_s2, multip * 60)
        rtd = f.dgn(rands, ncycles, rt_s1, rt_s2, multip * 10)
        ojd = f.dgn(rands, ncycles, 30, 30, multip * 4)
        
        
        # Define environment parameters
        pt_mean = round(mean(ptd, 2))  
        pt_sigm = round(sd(ptd, 2))    
        
        tf_mean = round(mean(tfd), 2)  
        tf_exp  = 1 / tf_mean          
        
        rt_mean = round(mean(rtd), 2)  
        oj_mean = round(mean(ojd), 2)  
        
        n_saws  = 3                    
        fc_dur  = du_choice() * 7 * 24 * 60      
        
        
        # Define environment
        list_for_rem = c("env", "other_jobs", "saws", "failure", "res")
        if (exists(x = "env")){rm(list_for_rem)}
        env = simmer()
        
        
        # Define sawmill processes
        other_jobs = 
          trajectory() %>%
          seize("repairman", 1) %>% 
          timeout(oj_mean) %>% 
          rollback(1, Inf)
        
        saws = paste0("saw", 1:n_saws - 1)
        
        failure =
          trajectory() %>%
          select(saws, policy = "random") %>% 
          seize_selected(1) %>% 
          seize("repairman", 1) %>% 
          timeout(rt_mean) %>% 
          release("repairman", 1) %>% 
          release_selected(1)
        
        for (i in saws) {
          env %>% 
            add_resource(i, 1, 0, preemptive = TRUE) %>% 
            add_generator(paste0(i, "_worker"), 
                          f.saw_logs(i, ptm = pt_mean, pts = pt_sigm), 
                          at(0), 
                          mon = 2)
        }
        
        env %>% 
          add_resource("repairman", 1, Inf, preemptive = TRUE) %>% 
          add_generator("repairman_worker", other_jobs, at(0)) %>% 
          invisible
        
        env %>% 
          add_generator("failure",
                        failure,
                        function() rexp(1, tf_exp * n_saws),
                        priority = 1) %>% 
          run(fc_dur) %>% invisible
        
        res = aggregate(value ~ name, get_mon_attributes(env), max)
        res = tidyr::spread(res, key = name, value = value)
        colnames(res) = c("saw1", "saw2", "saw3")
        
        df = data.frame(ptd, tfd, rtd)
        df = merge(df, res)
        waiter_hide()
        return(df)
      })
      
      output$plot1 = renderPlot({
        p = f.plotd(vals = vals_df()$ptd, nm = "process")
        return(p)
      })
      
      output$plot2 = renderPlot({
        p = f.plotd(vals = vals_df()$tfd, nm = "to failure")
        return(p)
      })
      
      output$plot3 = renderPlot({
        p = f.plotd(vals = vals_df()$rtd, nm = "repair")
        return(p)
      })
      
      output$plot4 = renderPlot({
        barplot(vals_df()[, 4:6] %>% 
                  dplyr::summarise_if(is.numeric, mean) %>% as.matrix(),
                main = paste("Total production output:", 
                             vals_df()[, 4:6] %>% 
                               dplyr::summarise_if(is.numeric, mean) %>% 
                               sum()),
                col  = "lightgreen")
      })
    }
  )
}