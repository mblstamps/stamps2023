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
# when combining all samples 