Rcpp::sourceCpp(here::here("src", "lapack.cpp"))

size <- 500

# likely well defined matrix
A <- matrix(rnorm(size ** 2), nrow=size, ncol=size) 
b <- matrix(rnorm(size), nrow=size, ncol=1)
print(sum(solve_lapack(A,b)))



# Large matrix for benchmarking
.size <- 250
A250 <- matrix(
	1 + 0.1 * rnorm(.size ** 2), 
	nrow=.size, ncol=.size
)  
b250 <- matrix(
	rnorm(.size), nrow=.size, ncol=1
)
.size = 500
A500 <- matrix(
	1 + 0.1 * rnorm(.size ** 2), 
	nrow=.size, ncol=.size
)  
b500 <- matrix(
	rnorm(.size), nrow=.size, ncol=1
)
.size <- 1000
A1000 <- matrix(
	1 + 0.1 * rnorm(.size ** 2), 
	nrow=.size, ncol=.size
)  
b1000 <- matrix(
	rnorm(.size), nrow=.size, ncol=1
)
.size <- 2000
A2000 <- matrix(
	1 + 0.1 * rnorm(.size ** 2), 
	nrow=.size, ncol=.size
)  
b2000 <- matrix(
	rnorm(.size), nrow=.size, ncol=1
)
bench::mark(
	slv_250   = sum(solve_lapack(A250,  b250)),
	slv_500   = sum(solve_lapack(A500,  b500)),
	slv_1000  = sum(solve_lapack(A1000, b1000)),
	slv_2000  = sum(solve_lapack(A2000, b2000)),
	check     = FALSE # so benchmark is ok 
	                  # with different results
)

# singular matrix 1: projector
A <- matrix(1, nrow=size, ncol=size)
print(sum(solve_lapack(A,b)))