Rcpp::sourceCpp(here::here("src", "armadillo_basics.cpp"))

# runtime benchmarking
size <- 5000 # start small
M <- matrix(runif(size ** 2), nrow=size, ncol=size) 

results <- microbenchmark::microbenchmark(
	col_wise_sum = colwise_sum(M),
	row_wise_sum = rowwise_sum(M),
	times = 50
)
print(results)

# runtime+memory benchmarking of matrix copies
result <- bench::mark(
	shallow_copy = shallow(M),
	deep_copy    = deep(M)
)
print(result)