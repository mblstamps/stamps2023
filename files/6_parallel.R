###############################################
#
# parallel
#
###############################################

# Before we begin, we load the 'foreach' and 'doParallel' packages
library(doParallel)
library(foreach)

# Next, we set the number of cores
# detectCores() returns the number of cores available in your machine.
# We subtract 1 to avoid processor issues.
no_cores <- detectCores() - 1
# We then tell R to make a create a cluster with the desired number of cores
cl <- makeCluster(no_cores)
# Lastly, we want to register the backend for our cluster.
registerDoParallel(cl)
# Use the help files of any of these commands to see more details
# and to learn about how to create different types of clusters,
# such as PSOCK or Fork. (Don't worry if this doesn't make sense).

# Now that we have a cluster registered, let's use it!
# Start by learning about the foreach() function.
?foreach

# The first argument is what we want to parallelize over.
# For example, this will commonly be an iteration count or
# index of something.

# Take a look at the code below, but don't run it yet!

######
# relative_abundances <- 
#   foreach(current_index = 1:ncol(abundances), 
#           .combine = cbind)  %dopar% {
#             number_reads <- sum(abundances[, current_index]) 
#             abundances[, current_index]/number_reads
#           }
#####

# In this example, we will calculate relative abundances.
# We will want to parallelize over the columns of our counts table,
# so we index our parallelization using 1:ncol(abundances).
# The .combine argument tells foreach how to combine our output.
# Our function, when only applied to one sample (not in parallel),
# will return a vector of relative abundances. We want to combine
# this output for each sample into a matrix, so we will 
# column bind them together using .combine = cbind.
# This is the end of the foreach arguments. 
# Next, we tell foreach to run in parallel over our cluster
# (which we already generated) using %dopar%.
# Finally, just like with any other loop, we wrap our 
# tasks in brackets, making sure to index our columns
# using the index argument we defined in foreach (current_index)!
relative_abundances <- 
  foreach(current_index = 1:ncol(abundances), 
          .combine = cbind)  %dopar% {
            number_reads <- sum(abundances[, current_index]) 
            abundances[, current_index]/number_reads
          }


# Let's check to make sure that our results match standard calculations
relative_abundances_nonparallel <- scale(abundances, center = F, scale = colSums(abundances))
all(relative_abundances == relative_abundances_nonparallel)

# NOTE:'.combine' can be specified as a function or 
# a character string e.g. c, cbind, rbind, list, '+', '*'

# Also observe that variables from the local environment are by default available
# in each core without specification. This is not true of the variables
# in the parent environment. For example, if we define our parallel 
# code as a function
this_should_break <- function() {
  foreach(current_index = 1:ncol(abundances), 
          .combine = cbind)  %dopar% {
            number_reads <- sum(abundances[, current_index]) 
            abundances[, current_index]/number_reads
          }
}

# and then run this function.
# This SHOULD break!
relative_abundances <- this_should_break()

# We can fix this by exporting specific variables to the cluster cores.
# To do this we use the 'export' argument.
this_should_work <- function() {
  foreach(current_index = 1:(dim(abundances)[2]), 
          .combine = cbind,
          .export = "abundances")  %dopar% {
            number_reads <- sum(abundances[, current_index]) 
            abundances[, current_index]/number_reads
          }
}
# It should now work if we run it.
relative_abundances <- this_should_work()

# Check if results match the standard calculations
all(relative_abundances == relative_abundances_nonparallel)

# When you are done working in parallel, we close the cluster
# so that resources are returned to the operating system
stopCluster(cl)


# The command lapply() is often a cleaner way to perform for loop tasks. 
# You can speed up apply-type functions using their parallel equivalents.
# For example, we use parLapply() to run lapply() in parallel,
# and we use parSapply() to run sapply() in parallel.
# These functions are available in the package parallel, 
# so let's install and load that package.
library(parallel)

# We closed our cluster earlier, so let's make another.
cl <- makeCluster(no_cores)

# Next we export our variable 'abundances' to all cluster cores.
clusterExport(cl, "abundances")

# NOTE: If you are using some specific packages inside parLapply, 
# you need to load them using clusterEvalQ().
# For example, if we want to make sure the cluster can use phyloseq, we use
# clusterEvalQ(cl, library(phyloseq))

# Let's try out parLapply. The structure is similar to foreach, the first
# argument is the name of our cluster, cl. Next, we define our 
# index variable as in foreach(). Finally, we define our function, similar
# to other apply-type functions.
relative_abundances <- 
  parLapply(cl, 
            1:ncol(abundances),
            function(current_index) {
              print(class(current_index))
              number_reads <- sum(abundances[, current_index]) 
              abundances[, current_index]/number_reads
            })

# Again, we close our cluster
stopCluster(cl)

# Since we used parLapply, relative_abundances is a list.
class(relative_abundances)

# To convert it to a matrix we use:
relative_abundances <- do.call("cbind", relative_abundances)
class(relative_abundances)
# It should now be of class "matrix"

# Check if results match the standard calculations
all(relative_abundances == relative_abundances_nonparallel)

# For more details on parallelization in R:
# http://gforge.se/2015/02/how-to-go-parallel-in-r-basics-tips/
