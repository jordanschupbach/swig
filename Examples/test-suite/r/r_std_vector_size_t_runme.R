clargs <- commandArgs(trailing=TRUE)
source(file.path(clargs[1], "unittest.R"))

dyn.load(paste("r_std_vector_size_t", .Platform$dynlib.ext, sep=""))
source("r_std_vector_size_t.R")
cacheMetaData(1)

v <- make_sizes()
unittest_sequence(v, as.integer(c(10, 20, 30)))
unittest(sum_sizes(c(1, 2, 3)), 6)
unittest(sum_sizes(v), 60)
unittest(sum_sizes_by_value(4:6), 15)

q(save="no")
