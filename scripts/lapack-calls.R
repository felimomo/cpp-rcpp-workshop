Rcpp::sourceCpp(here::here("src", "lapack.cpp"))

size <- 500

# likely well defined matrix
A <- matrix(rnorm(size ** 2), nrow=size, ncol=size) 
b <- matrix(rnorm(size), nrow=size, ncol=1)

print(solve_lapack(A,b))

# singular matrix 1: projector
A <- matrix(1, nrow=size, ncol=size)
print(solv_lapack(A,b))

# Large matrix for benchmarking
A250 <- matrix(
	1 + 0.1 * rnorm(250 ** 2), 
	nrow=250, ncol=250
)  
A500 <- matrix(
	1 + 0.1 * rnorm(500 ** 2), 
	nrow=500, ncol=500
)  
A1000 <- matrix(
	1 + 0.1 * rnorm(1000 ** 2), 
	nrow=1000, 
	ncol=1000
)  
bench::mark(
	slv_250   = solve_lapack(A250,  b),
	slv_500   = solve_lapack(A500,  b),
	slv_1000  = solve_lapack(A1000, b),
)