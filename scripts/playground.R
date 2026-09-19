#!/usr/bin/env Rscript

# Just a little playground to test out the
# Armadillo <-> Rcpp <-> R integration
# Will just pile on quick tests one after the other.

Rcpp::sourceCpp(here::here("src", "armadillo_basics.cpp"))

# n_row, n_col
Mat <- matrix(
	rnorm(30, mean=1, sd=0.05),
	nrow = 6,
	ncol = 5
)
print(row_col_n(Mat))