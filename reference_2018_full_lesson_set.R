###############################################
# 
# Setup
#
###############################################

# First, set your working directory to wherever you want to 

utils::download.file("LINK", "R_tutorial.zip")
utils::unzip("R_tutorial.zip")

# We will move into the folder to make sure that everyone is working within the same directory
setwd("./STAMPS2018")

# Before moving on, check to make sure you have 7 ".R" files and 2 ".txt" files
list.files()

# If you have that, then load in the data we'll be using
covariates <- read.csv("FWS_covariates.txt", sep = "\t")
abundances <- read.csv("FWS_OTUs.txt", sep = "\t", row.names = 1, header = T)

# Let's install 
install.packages("dplyr")
install.packages("magrittr")
install.packages("devtools")
devtools::install_github("adw96/breakaway")
install.packages("ggplot2")
install.packages("phyloseq")
install.packages("parallel")
install.packages("foreach")
install.packages("doParallel")


###############################################
# 
# loops
#
###############################################

# R is a vectorised language, so for a function that takes 1 argument, 
# you can apply across a vector
abundances[, 1] + 5
abundances[, 1]^2

# What about for more complex functions?


# In most cases, dplyr takes care of this for us, first, let's laod it
library(dplyr) 
library(magrittr)

# Now we 
covariates %>%
  select(SampleName, Location, Season) 
# loops through the columns of covariates to select certain variables, and
covariates %>%
  filter(Location == "MBL") 
# loops through the rows to find only those satisfying `Location == "MBL"`

# To familiarise ourselves with more R functions, 
# let's see how to get the relative abundance of the taxa
# in a number of different ways 

# To scale the values in each column by dividing the values by the column total,
# we can use the scale() function:
taxaRel <- scale(abundances, center=FALSE, scale=colSums(abundances)) 
head(taxaRel)
# Check that the columns now all sum to 1 (=100%)
colSums(taxaRel)  # colSums finds the sum of each column

# We *could* also do this same thing by manually looping over the
# columns
# This isn't the best way to do this task, but it introduces
# loops, which can be helpful

# Let's look at for() loops
for (my_index in 1:5) { # cycling through the columns...
  print(paste("The ", my_index, "th sample is called ", 
              covariates$SampleName[my_index], "!", sep=""))
}
# my_index is a variable that the loop creates to... well... loop!

# Going back to the relative abundances ...
relative_abundances <- matrix(NA, # create a matrix of the same size as abundances
                              nrow = nrow(abundances),
                              ncol = ncol(abundances))
colnames(relative_abundances) <- colnames(abundances)
rownames(relative_abundances) <- rownames(abundances)
for (the_index in 1:ncol(abundances)) { # cycling through the columns...
  number_reads <- sum(abundances[, the_index]) # find the column total
  relative_abundance <- abundances[, the_index]/number_reads # use it to find relative abundance
  relative_abundances[, the_index] <- relative_abundance # save the current column into our new matrix
}
head(relative_abundances)

# we can track that this matches our original calculation with
all(relative_abundances == taxaRel)

# what does all() do?
?all

# Cool function: strsplit() splits up strings
rownames(abundances)[1]
strsplit(rownames(abundances)[1], ";")

# Challenging but valuable exercise: 
# Use a for loop to find which phylum was observed most frequently
# when combining all samples ###############################################
# 
# The apply family
#
###############################################

# Unfortunately, for loops, while intuitive and broadly useful, 
# are relatively slow in R

# apply() is a much better way of doing this!

fast_total_reads <- apply(abundances, 2, sum)
# what does the second argument 2 do? Compare to second argument of 1
# Find out with ?apply

# sweep() is related to apply()
sweep(abundances, 2, fast_total_reads, "/")
# "go down the columns of abundances, applying "/" (division) to each column,
# with the second argument of the division being the element of
# fast_total_reads corresponding to the column number of abundances
# This should evaluate to TRUE
all(sweep(abundances, 2, fast_total_reads, "/") == relative_abundances)


# Careful! dividing a matrix by a vector divides across the rows, 
# not the columns! 
# This should evaluate to FALSE
all(abundances/fast_total_reads == relative_abundances)

# sapply(), mapply(), tapply(), lapply() 
# are all variations on apply for different 
# situations

# Use lapply if you want to return a list
mylist <- lapply(abundances, sum)
# Check the class of this object using
class(mylist)

# You can turn that list back into a vector (or matrix, depending on the output) using simplify2array
mylist %>% simplify2array

# This is equivalent to the command sapply
myvec <- sapply(abundances,  sum)
# Check the class of this file
class(myvec)

# (Note from Amy, cerca 2014) 
# In writing this tutorial, I just learnt about prop.table,
# which turns a matrix into its relative abundances across a fixed margin.
# Cool!
all(prop.table(as.matrix(abundances), margin = 2) == relative_abundances)###############################################
# 
# Function writing
#
###############################################

# writing functions is easy in R!
my_first_function <- function() {
  cat("Hello World!")
}
my_first_function()
# This is a function with no arguments

# Functions can have no arguments, or several arguments:
my_second_function <- function(times) {
  counter <- 1
  while (counter <= times) { # while() is a type of loop
    cat("Hello World!\n")
    counter <- counter + 1
  }
}
my_second_function(3)

# If you are dealing with one OTU table, turning it into
# relative abundance table is pretty easy. But what if you have 
# to do it for many OTU tables?

# Exercise: Write a function that takes in an OTU table
# and returns the relative abundance table

# Note that you can construct functions inline:
apply(abundances, 2, function(x) {x/sum(x)})###############################################
# 
# Lists
#
###############################################

# Lists are great! Lists allow you to combine many different types of data
# of many different sizes into groups

# We're going to make a list corresponding to all of the information
# about the first sample

class(abundances)
names(abundances)

sample1 <- list()
sample1$name <- covariates$SampleName[1]
sample1$season <- covariates$Season[1]
sample1$place <- covariates$Location[1]
sample1$counts <- abundances[,1]

# to see all the information in a list, go
sample1
# to see just the beginning
head(sample1)
# and to see a particular element of the list, 
# place the name of that element after the sign $
sample1$name

# Exercise: 
# Write a function to take a SampleName and create a list of the above components
# e.g. your_function("MBL_Jan") return a list with elements name, season, place, 
# and counts
# i.e. your_function("JPA_Jan") == sample1  should be TRUE

# Extend your function to include relative abundance

# you can also make a list of lists!
all_samples <- list()
all_samples$sample1 <- sample1
all_samples$sample2 <- list()
all_samples$sample2$name <- covariates$SampleName[2]
all_samples

# You can also use the following naming/assigning convention
all_samples[["sample3"]] <- list()
all_samples$sample3


# You can change the names of the elememts of a list, too!
# Suppose we want to capitalise them
# Instead of 
names(all_samples) 
# we could overwrite it with
names(all_samples) <- paste("Sample", 1:3)
names(all_samples) 
# paste() pastes strings together

# Double brackets can also be used to refer to the elements of a list, 
# instead of naming them individually
all_samples[[1]]
all_samples[[2]]


# Exercise: Use a loop to loop through all of the samples, 
# creating a list of the information corresponding to that sample.
# (name, location, month, relative abundance table, abundance table)



# Hint 1: Use your function from previously!

# Hint 2: Think about what you should loop over in the outermost loop



# Congratulations! You are at a level with your R understanding
# that will get you through most of STAMPS! If you feel so inclined,
# have a look through source_system.R, parallel.R, and markdown.R,
# but at this point, you probably deserve
# a cold beverage and a break!


###############################################
#
# source and system
#
###############################################



# Exercise: Use source() to run an R script in this session
# Also works for URLs!
?source

# Let's start by practicing sourcing a file.
# First, create a new R file by navigating to File -> New File -> R Script

# Exercise: Write a function called "my_sample_richness".
# This function should take in a vector of counts and returns
# sample richness (the number of OTUs with non-zero count in the sample).

# Then, save this file in your working directory and call it sample_richness.R.
# In the same file, include the following function from earlier:
my_first_function <- function() {
  cat("Hello World!")
}

# Finally, add this line to the bottom of the R script file:
cat("This line is being evaluated!")

# Let's test that our functions work on the counts.
# This should return the sample richness.
my_sample_richness(abundances[,1])
my_first_function()

# Next, let's remove these functions from our environment, so R
# is no longer aware that the functions exist.
rm(my_sample_richness)
rm(my_first_function)

# What happens when we try to run our functions again?
my_sample_richness(abundances)
my_first_function()

# You SHOULD see an error!
# They will not run if we cleared the functions correctly.
# Since we have saved our functions in a file, we can source 
# this file to put the functions back into our environment.

# First, let's check our working directory using
getwd()

# Make sure that the output matches the folderpath of "sample_richness.R".
# If it doesn't, use setwd("YOUR FOLDERPATH") to change it.

# Next, we source the file. We use `.` to refer to the 
# current working directory to save space. This is not only
# easier, but it also makes our code more reproducible if we 
# move files around.
source("./sample_richness.R")

# If everything was done correctly, you should see the string
# "This line is being evaluated!"

# When you source a file, R evaluates the entire file from top
# to bottom. Let's check to see if the rest of the file compiled.
apply(my_sample_richness, 2, abundances)
my_first_function()

# Hopefully, these functions are now working again!

# Why should you bother with this?
# First, it is easier to organize your code.
# It also makes it easier to ensure that you correctly 
# reload all files and functions for your current projects,
# even if you close R and come back to it later.

# For example, perhaps for a project you need sample_richness,
# along with several other functions and package dependencies.
# You can save these all in one R script, call it
# something like "preamble.R", and then whenever you restart
# on a project, instead of manually making sure everything is 
# there, you can simple type `source("./preamble.R")`
# to load everything you need.

###############################################################

# We can use system() to run a system command. 
# In the alpha diversity lab we will see an example of this 
# running CatchAll via the command line
?system

# To see how this works, if you have a Mac or Linux machine, use
system("say I am running a terminal command through R!")
# If you have a Windows machine, print your working directory using
system("dir")
# Macs and Linux machines can also do this using
system("ls")

# Compare this output to the output of the equivalent file in R using.
list.files()

# Advanced Exercise: Write a script to separate out the different 
# taxonomy data in shell and run it through R









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
###############################################
#
# Markdown
#
###############################################

## Rmarkdown is a great way to combine R code with text, either to
## share your work with others or to keep notes for yourself.
## Markdown is a lightweight text formatting system. It gives you
## control over some simple things, like headings, bold/italic, and
## links, but the idea is that when you write a markdown document you
## focus on the text and not on the formatting. Markdown documents are
## readable as plain text, and can later be formatted as html.
##
## There is a short tutorial at http://www.markdowntutorial.com/ that
## allows you to go through some examples. You should work through it,
## as it only takes a couple of minutes.
##
## Once you know about markdown, Rmarkdown is a simple extension. It
## allows you to place R code into markdown documents, and the R code
## and markdown text can then be processed with knitr to create an
## html document containing both. Knitr will run the R code, create
## any output or plots described in the code, and create a single html
## document containing everything. Adding R code to a markdown
## document is just a matter of putting
##
## ```{r chunk_name}
##
## before the R code (without the leading ##, and with chunk_name
## replaced with a descriptive name for what the code does), and
## putting
##
## ```
##
## below the R code to indicate the end of a chunk (again, without the
## leading ##).
##
## Rmarkdown (Rmd) documents can be converted to html using the render
## command in rmarkdown package, so if you have a file called
## my_rmarkdown.Rmd it can be converted to html using
## render("my_rmarkdown.Rmd"). If you are using Rstudio, there is a
## button "knit" that will do this for you.
##
##
## Exercise: Make your own Rmd document with some of the code and
## plots from the ggplot lecture. Try modifying the width and
## height of the figures (look at the fig.width and fig.height options
## on this web page: https://yihui.name/knitr/options/).
