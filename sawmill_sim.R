# Scenario:
# A sawmill has *n* identical saws. A stream of logs to keep them busy arrives.
# Each saw breaks down periodically. One repairman takes care of all repairs.
# The repairman has other minor priority tasks to do too. The repairman returns
# to them when he has the saws repaired. The sawmill works 24/7.

# Load libraries
# Load custom functions
rm(list = ls())
library(simmer)
library(dplyr)
setwd("/home/daria/Documents/projects/discrete_event_sim/")
source("distr_generator.R")


# Define distribution parameters
# Visualize distributions
rands   = 3    # random seed
ncycles = 1e6  # number of observations
multip  = 10   # multiplier which converts distribution to minutes

f.dpl(rands, ncycles, 7, 40, multip)       # process time
f.dpl(rands, ncycles, 20, 2, multip * 60)  # time to failure
f.dpl(rands, ncycles, 30, 30, multip * 10) # repair time
f.dpl(rands, ncycles, 10, 30, multip * 10) # other jobs


# Generate distributions for process time, time to failure, repair time, other
# repair jobs duration. All distributions in minutes.
ptd = f.dgn(rands, ncycles, 7, 40, multip)
tfd = f.dgn(rands, ncycles, 20, 2, multip * 60)
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







