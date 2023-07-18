###############################################
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
apply(abundances, 2, function(x) {x/sum(x)})