# Scenario:
# A sawmill has *n* identical saws. A stream of logs to keep them busy arrives.
# Each saw breaks down periodically. One repairman takes care of all repairs.
# The repairman has other minor priority tasks to do too. The repairman returns
# to them when he has the saws repaired. The sawmill works 24/7.

# Load libraries
# Load custom functions
rm(list = ls())
library(dplyr)
library(simmer)
setwd("/home/daria/Documents/projects/discrete_event_sim/")
source("distr_generator.R")


# Define distribution parameters
# Visualize distributions
rands   = 3    # random seed
ncycles = 1e5  # number of observations
multip  = 10   # multiplier which converts distribution to minutes

f.dpl(rands, ncycles, 30, 10, multip)         # process time
f.dpl(rands, ncycles, 10, 10, multip * 60)   # time to failure
f.dpl(rands, ncycles, 30, 30, multip * 10)   # repair time
f.dpl(rands, ncycles, 10, 30, multip * 10)   # other jobs


# Generate distributions for process time, time to failure, repair time, other
# repair jobs duration. All distributions in minutes.
ptd = f.dgn(rands, ncycles, 7, 40, multip)
tfd = f.dgn(rands, ncycles, 10, 10, multip * 60)
rtd = f.dgn(rands, ncycles, 30, 30, multip * 10)
ojd = f.dgn(rands, ncycles, 10, 30, multip * 10)


# Define environment parameters
pt_mean = round(mean(ptd), 2)  # mean process time
pt_sigm = round(sd(ptd), 2)    # standard deviation of process time

tf_mean = round(mean(tfd), 2)  # mean time to failure
tf_exp  = 1 / tf_mean          # mean time to failure for exponential distr

rt_mean = round(mean(rtd), 2)  # mean repair time
oj_mean = round(mean(ojd), 2)  # mean other job time

n_saws  = 3                    # number of saws
fc_dur  = 4 * 7 * 24 * 60      # 4 weeks sim duration in minutes


# Remove distributions and temp variables
rm(ptd, tfd, rtd, ojd)
rm(ncycles, multip, rands)


# Setup environment
set.seed(123)
env = simmer()


# Define functions
source("traj_functions.R")


# Define repairman's minor jobs
# A repairman starts a job and does jobs in an infinite loop. He does not
# count the jobs done.
other_jobs = 
  trajectory() %>%
  seize("repairman", 1) %>% 
  timeout(oj_mean) %>% 
  rollback(1, Inf)


# Failures happen randomly. Each failure seizes and calls for the repairman.
# After the repairman has the saw running again, both resources are free
# and begin where the left.
saws = paste0("saw", 1:n_saws - 1)

failure =
  trajectory() %>%
  select(saws, policy = "random") %>% 
  seize_selected(1) %>% 
  seize("repairman", 1) %>% 
  timeout(rt_mean) %>% 
  release("repairman", 1) %>% 
  release_selected(1)


# Append saws and workers to the simulation environment. Each saw has space
# for one worker and no space in queue
for (i in saws) {
  env %>% 
    add_resource(i, 1, 0, preemptive = TRUE) %>% 
    add_generator(paste0(i, "_worker"), 
                  f.saw_logs(i, ptm = pt_mean, pts = pt_sigm), at(0), mon = 2)
}


# Append repairman to the simulation environment. He has an infinite queue as
# at any given time any saw can break.
env %>% 
  add_resource("repairman", 1, Inf, preemptive = TRUE) %>% 
  add_generator("repairman_worker", other_jobs, at(0)) %>% 
  invisible


# Define failure generator
env %>% 
  add_generator("failure",
                failure,
                function() rexp(1, tf_exp * n_saws),
                priority = 1) %>% 
  run(fc_dur) %>% invisible


# Get results
res = aggregate(value ~ name, get_mon_attributes(env), max)
barplot(res$value)
res

# Get arrivals
arrivals = simmer::get_mon_arrivals(env)
arrivals = 
  arrivals %>% 
  dplyr::select(-c(finished, replication)) %>% 
  dplyr::mutate(flow_time = end_time - start_time) %>% 
  dplyr::mutate(waiting_time = flow_time - activity_time)
arrivals = arrivals[-1, ]
arrivals = arrivals %>% dplyr::select(end_time, waiting_time)


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


# to do: visualize simulation output
# to do: publish description in .Rmd
