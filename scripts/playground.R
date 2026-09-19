#!/usr/bin/env Rscript

# Just a little playground to test out the
# Armadillo <-> Rcpp <-> R integration
# Will just pile on quick tests one after the other.

Rcpp::sourceCpp(here::here("src", "armadillo_basics.cpp"))

# n_row, n_col
print("Matrix col row number test:")
Mat <- matrix(
	rnorm(30, mean=1, sd=0.05),
	nrow = 6,
	ncol = 5
)
print(row_col_n(Mat))

# cumsum, threshold flags:
print("Vec cumsum threshold test:")
v <- runif(10)
thr <- 1.0
cat(
	"vector:", 
	sprintf("%.2f",v), "\n", sep=', '
)
cat(
	"cumsum:", 
	sprintf("%.2f",cumsum(v)), "\n", sep=', '
)
cat("<=thr.:", cumsum_lt_thresh(v, thr), "\n", sep=', ')