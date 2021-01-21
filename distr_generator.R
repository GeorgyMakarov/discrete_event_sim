# Generates density plot of a distribution based on changing parameters
# Use to simulate variable behaviour
# Params s1 and s2 change the skeweness and form of distribution
# @name     f.dpl
# @param    rd  seed for reproducibility
# @param    nb  number of observations
# @param    s1  shape1 of beta distribution
# @param    s2  shape2 of beta distribution
# @param    mf  multiplication factor to convert distribution to units of choice
# @return   density plot
# @export

f.dpl = function(rd, nb, s1, s2, mf) {
    set.seed(rd)
    d  = density(rbeta(n = nb, shape1 = s1, shape2 = s2) * mf)
    p1 = plot(d, main = "density plot", frame = F, col = "darkgreen")
    p2 = polygon(d, col = rgb(0, 1, 0, alpha = 0.5))
}


# Generates distribution with given parameters
# Use to generate distributions for integer / decimal variables
# Params s1 and s2 change the skeweness and form of distribution
# @name     f.dgn
# @param    rd  seed for reproducibility
# @param    nb  number of observations
# @param    s1  shape1 of beta distribution
# @param    s2  shape2 of beta distribution
# @param    mf  multiplication factor to convert distribution to units of choice
# @param    ro  should round up the values if TRUE, default FALSE
# @return   density plot
# @export
f.dgn = function(rd, nb, s1, s2, mf, ro = FALSE) {
    set.seed(rd)
    x = rbeta(n = nb, shape1 = s1, shape2 = s2) * mf
    if (ro == TRUE) {
        x = round(x, 0)
    }
    x
}


# Examples

# ## generate number of patients waiting in a queue with right skew
# f.dpl(3, 100000, 2, 20, 10)                 # plot distribution
# rskew = f.dgn(3, 100000, 2, 20, 10, T)      # generate distribution
# hist(rskew, col = "lightgreen", breaks = 5) # plot and compare to f.dpl
# 
# ## generate number of patients waiting in a queue with left skew
# f.dpl(3, 100000, 20, 2, 10)                 # plot distribution
# lskew = f.dgn(3, 100000, 20, 2, 10, T)      # generate distribution
# hist(lskew, col = "lightgreen", breaks = 5) # plot and compare to f.dpl