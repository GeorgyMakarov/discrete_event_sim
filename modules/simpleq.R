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
                
                ## compute waiting time for arrivals
                df = simmer::get_mon_arrivals(env)
                df = 
                    df %>% 
                    dplyr::select(-c(finished, replication)) %>% 
                    dplyr::mutate(flow_time = end_time - start_time) %>% 
                    dplyr::mutate(waiting_time = flow_time - activity_time)
                df = df[-1, ]
                df = df %>% dplyr::select(end_time, waiting_time)
                
                ## compute resources utilization
                resources = simmer::get_mon_resources(env)
                resources = 
                    resources %>% 
                    dplyr::group_by(resource, replication) %>% 
                    dplyr::mutate(dt = time - dplyr::lag(time)) %>% 
                    dplyr::mutate(in_use = dt * dplyr::lag(server / capacity)) %>% 
                    dplyr::summarise(utilization = sum(in_use, na.rm = T) / sum(dt, na.rm = T))
                resources = resources %>% dplyr::select(-replication)
                resources = tidyr::spread(resources, 
                                          key = resource, 
                                          value = utilization)
                
                ## attach resources to arrivals data frame
                df = merge(df, resources)
                
                return(df)
            })
            
            
            ## plot waiting time
            output$plot1 = renderPlot({
                plot(x    = vals_df()$end_time,
                     y    = vals_df()$waiting_time,
                     main = paste("Waiting time. Mean:", 
                                  round(mean(vals_df()$waiting_time), 1),
                                  "min"),
                     xlab = "simulation time, min",
                     ylab = "waiting time, min",
                     type = "l",
                     col  = "blue",
                     lwd  = 2,
                     frame = F)
            })
            
            ## plot resource utilization
            output$plot2 = renderPlot({
                
            })
        }
    )
}