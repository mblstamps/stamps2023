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









