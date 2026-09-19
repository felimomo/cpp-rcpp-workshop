#include <RcppArmadillo.h>

Rcpp::IntegerVector row_col_n(const arma::mat& X) {
  return Rcpp::IntegerVector::create(
    Rcpp::Named("rows") = X.n_rows,
    Rcpp::Named("cols") = X.n_cols
  );
}

Rcpp::BoolVector cumsum_lt_thresh(
	const arma::vec& v, 
	const double thresh
){
	return cumsum(v) <= thresh;
}