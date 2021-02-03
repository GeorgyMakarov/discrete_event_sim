# Module demonstrates simple queue simulation


# Module UI
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


# Module server logic
simple_module_server = function(id){
    moduleServer(
        id,
        function(input, output, session){
            
            vals_df = eventReactive(input$run, {
                ## define choice of params
                nurse = reactive({input$nurses})
                doct  = reactive({input$doctors})
                admin = reactive({input$admins})
                
                ## define environment
                if (exists(x = "env")) {rm(env, patient)}
                env = simmer("outpatient_clinic")
                
                ## define trajectory and interactions -- how patient is served
                patient = trajectory("patient_path") %>% 
                    seize("nurse", 1) %>% 
                    timeout(function() rnorm(1, 15)) %>% 
                    release("nurse", 1) %>% 
                    
                    seize("doctor", 1) %>% 
                    timeout(function() rnorm(1, 20)) %>% 
                    release("doctor", 1) %>% 
                    
                    seize("administration", 1) %>% 
                    timeout(function() rnorm(1, 5)) %>% 
                    release("administration", 1)
                
                ## add resources -- use reactive values from sliders
                env %>% 
                    add_resource("nurse", nurse()) %>% 
                    add_resource("doctor", doct()) %>% 
                    add_resource("administration", admin()) %>% 
                    add_generator("patient", patient, function() rnorm(1, 5, 0.5))
                
                ## run simulation for 540 mins
                env %>% run(until = 540)
                
                ## return monitored resources
                df = env %>% get_mon_arrivals()
                df = df %>% dplyr::select(end_time, start_time)
                return(df)
            })
            
            
            # TO DO -- fix plot
            output$plot1 = renderPlot({plot(x = vals_df()$end_time,
                                            y = vals_df()$start_time,
                                            main = "Waiting time evolution",
                                            xlab = "simulation time",
                                            ylab = "waiting time",
                                            type = "l",
                                            col  = "blue",
                                            lwd  = 2,
                                            frame = F)})
        }
    )
}