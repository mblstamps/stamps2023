###############################################
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


