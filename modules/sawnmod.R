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


saw_module_ui = function(id){}

saw_module_server = function(id){}