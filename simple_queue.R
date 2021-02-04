# This script simulates a simple queue of patients in a clinic.
# It uses an example from Stat Pharm for the reference

library(simmer)
library(magrittr)
rm(list = ls())

# Create new simulation environment
env = simmer("outpatient_clinic")
env

# Define patient trajectory and interactions -- this describes how a
# patient is served in a clinic
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


# Add resources to the model
# Add generator of arriving patients
env %>% 
  add_resource("nurse", 3) %>% 
  add_resource("doctor", 4) %>% 
  add_resource("administration", 2) %>% 
  add_generator("patient", patient, function() rnorm(1, 5, 0.5))

env %>% run(until = 540)


# Plot metric of interest
library(simmer.plot)
plot(env,
     what   = "arrivals",
     metric = "waiting_time")



# Get arrivals
# Compute flow_time = end_time - start_time
# Compute waiting_time = flow_time - activity_time
arrivals = simmer::get_mon_arrivals(env)
arrivals = 
  arrivals %>% 
  dplyr::select(-c(finished, replication)) %>% 
  dplyr::mutate(flow_time = end_time - start_time) %>% 
  dplyr::mutate(waiting_time = flow_time - activity_time)
arrivals = arrivals[-1, ]
arrivals = arrivals %>% dplyr::select(end_time, waiting_time)

# Plot waiting time evolution using base plot
plot(x    = arrivals$end_time,
     y    = arrivals$waiting_time,
     main = paste("Waiting time. Mean:", 
                  round(mean(arrivals$waiting_time), 1),
                  "min"),
     xlab = "simulation time, min",
     ylab = "waiting time, min",
     type = "l",
     col  = "blue",
     lwd  = 2,
     frame = F)