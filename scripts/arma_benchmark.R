Rcpp::sourceCpp(here::here("src", "armadillo_basics.cpp"))

# runtime benchmarking
size <- 5000 # start small
M <- matrix(runif(size ** 2), nrow=size, ncol=size) 

colw_roww_res <- microbenchmark::microbenchmark(
	col_wise_sum = colwise_sum(M),
	row_wise_sum = rowwise_sum(M),
	times = 50
)
print(colw_roww_res)

# runtime benchmarking of matrix copies
shallow_deep_res <- bench::mark(
	shallow_copy = shallow(M),
	deep_copy    = deep(M)
)
print(shallow_deep_res)

# memory allocation testing in C++ and R
Rcpp::sourceCpp(here::here(
	"MemoryTesting", 
	"read_modify.cpp"
))

measure <- function(f, M) { 
	alloc_reset(); 
	invisible(f(M)); 
	alloc_mb() 
}

# let's test copying vs viewing on C++:
print(measure(cpp_copy, M))
print(measure(cpp_view, M))

# a similar mechanism is observed in R, where
# modifying a matrix autotriggers a deep copy
# of the matrix:
modify_r <- function(X) { 
	X[1, 1] <- 0; # triggers copy
	sum(X) 
}
readonly_r <- function(X) { 
	sum(X) # read-only for M
}

mem_results <- bench::mark(
	modify_r(M), 
	readonly_r(M), 
	check = FALSE
)
print(mem_results)