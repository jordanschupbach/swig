clargs <- commandArgs(trailing=TRUE)
source(file.path(clargs[1], "unittest.R"))

dyn.load(paste("r_overload_vector_vector", .Platform$dynlib.ext, sep=""))
source("r_overload_vector_vector.R")
cacheMetaData(1)

unittest(count_rows(list(c(1, 2))), 1)
unittest(count_rows(list(c(1, 2), c(3, 4, 5))), 2)
unittest(count_rows(list(c(1, 2), 3L, c(4.5, 6))), 3)
unittest(count_rows(2.5), -1)

unittest(count_int_rows(list(1:2, 3:5)), 2)
unittest(count_int_rows(4L), -1)

q(save="no")
