# Define categories for process time slider input
proc_name = c("Low", "Low-medium", "Medium", "Medium-high", "High")
proc_time = c(2/20, 5/20, 20/20, 20/5, 20/2)
names(proc_time) = proc_name


# Define distribution parameters
rands   = 3    # random seed
ncycles = 1e4  # number of observations
multip  = 10   # multiplier which converts distribution to minutes


# Define base parameters for sliders
tf_base = 30
rt_base = 30


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
        du_choice = reactive({input$duration})
        
        
        #Compute s1 and s2 parameters for process time
        #Take into account the combination of s1 and s2 from pt choice
        # Compute process time distribution
        pt_chosen = reactive({proc_time[pt_choice()]})
        if (pt_chosen() <= 1) {
          proc_s1 = 20 * pt_chosen()
          proc_s2 = 20
        } else if (pt_chosen() > 1) {
          proc_s1 = 20
          proc_s2 = 20 / pt_chosen()
        }
        
        ptd = f.dgn(rands, ncycles, proc_s1, proc_s2, multip)
        
        
        # Temp solution -- update with code
        tfd = f.dgn(rands, ncycles, 10, 10, multip * 60)
        rtd = f.dgn(rands, ncycles, 30, 30, multip * 10)
        ojd = f.dgn(rands, ncycles, 10, 30, multip * 10)
        
        
        df = data.frame(ptd, tfd, rtd, ojd)
        return(df)
      })
      
      output$plot1 = renderPlot({
        plot(x = vals_df()$ptd, 
             col = "blue", 
             main =paste("Number of observations is", length(vals_df()$ptd)))
      })
      
    }
  )
}