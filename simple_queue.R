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
  add_resource("administration", 1) %>% 
  add_generator("patient", patient, function() rnorm(1, 5, 0.5))

env %>% run(until = 540)


# Plot the results
library(simmer.plot)
plot(env, 
     what   = "resources",
     metric = "usage",
     c("nurse", "doctor", "administration"),
     items  = c("server", "queue"))

# Plot metric of interest
plot(env,
     what   = "arrivals",
     metric = "waiting_time")


# Plot with basic plotting system
arrivals = get_mon_arrivals(env)
plot(x    = arrivals$end_time,
     y    = arrivals$start_time,
     main = "Waiting time evolution",
     xlab = "simulation time",
     ylab = "waiting time",
     type = "l",
     col  = "blue",
     lwd  = 2,
     frame = F)

