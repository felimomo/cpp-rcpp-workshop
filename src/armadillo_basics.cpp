// [[Rcpp::depends(RcppArmadillo)]]
// 
//  -> so that sourceCpp in R knows where to find the 
//     header 
// 
// Also note: [[Rcpp::export]] exports a function
//            so it's visible from R

#include <RcppArmadillo.h>

// [[Rcpp::export]]
Rcpp::IntegerVector row_col_n(const arma::mat& X) {
  return Rcpp::IntegerVector::create(
    Rcpp::Named("rows") = X.n_rows,
    Rcpp::Named("cols") = X.n_cols
  );
}

// [[Rcpp::export]]
Rcpp::LogicalVector cumsum_lt_thresh(
	const arma::vec& v, 
	const double thresh
){
	arma::uvec thr_flags = cumsum(v) <= thresh;
	return Rcpp::LogicalVector(
		thr_flags.begin(),
		thr_flags.end()
	);
}