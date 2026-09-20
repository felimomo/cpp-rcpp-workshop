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

// Contracting armadillo matrices col-wise vs row-wise.
// Use in time benchmarking for large matrices.
// (The point here is that arma matrices are column-major
// so row-lists for each column are contiguous in memory.
// This effect is visible if matrices are bigger than L3
// (they cannot be entirely held in CPU cache))

// [[Rcpp::export]]
double colwise_sum(arma::mat& M){
	// note arma::uword is unsigned integer, which is what
	// M.n_rows and M.n_cols are (otherwise the compiler will
	// throw a warning).
	double total = 0.0;
	for(arma::uword j = 0; j < M.n_cols; ++j){
		for(arma::uword i = 0; i < M.n_rows; ++i){
			// inner loop through things contiguous in memory
			total += M.at(i,j); // no bound checking, for benchm.
		}
	}
	return total;
}

// [[Rcpp::export]]
double rowwise_sum(arma::mat& M){
	double total = 0.0;
	for(arma::uword i = 0; i < M.n_rows; ++i){
		for(arma::uword j = 0; j < M.n_cols; ++j){
			// inner loop through non-contiguous memory elements
			total += M.at(i,j);
		}
	}
	return total;
}

// Memory allocation within C++ not visible to R
// on the outer API call. What will be visible
// is the time it takes to make the copy.

// [[Rcpp::export]]
void shallow(arma::mat& M){
	arma::mat& X = M; // shallow copy
}

// [[Rcpp::export]]
void deep(arma::mat& M){
	arma::mat X = M; // deep copy
}

// Memory testing on two similar-looking 
// Rcpp functions.

// making an actual data copy
// [[Rcpp::export]]
double cpp_copy(
  const Rcpp::NumericMatrix& Mr
) {
  arma::mat M = Rcpp::as<arma::mat>(Mr);   
  return arma::accu(M);
}

// Making a view-only copy (view R's memory)
//   => M.memptr() IS Mr.begin(). 
// note: need copy_aux_mem = false below
// [[Rcpp::export]]
double cpp_view(
  const Rcpp::NumericMatrix& Mr
) {
  const arma::mat M(const_cast<double*>(
    Mr.begin()), 
    Mr.nrow(), 
    Mr.ncol(),
    false,       // copy_aux_mem
    true         // strict (pin version to R buffer: 
);               // can't resize later in the function)

  return arma::accu(M);
}

