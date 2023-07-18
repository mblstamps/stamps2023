###############################################
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
all(prop.table(as.matrix(abundances), margin = 2) == relative_abundances)