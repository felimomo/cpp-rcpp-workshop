Rcpp::sourceCpp(here::here("src", "armadillo_basics.cpp"))
library(microbenchmark)

size <- 5000 # start small
M <- matrix(runif(size ** 2), nrow=size, ncol=size) 

results <- microbenchmark(
	col_wise_sum = colwise_sum(M),
	row_wise_sum = rowwise_sum(M),
	times = 50
)
print(results)