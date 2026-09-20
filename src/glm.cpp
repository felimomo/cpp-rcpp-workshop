// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// lapack interface
extern "C" {
  void dgesv_(
    const int* n,   const int* nrhs, 
    double* a,      const int* lda,
    int* ipiv,      double* b, 
    const int* ldb, int* info);
}

// [[Rcpp::export]]
arma::vec glm_dgesv_fit(
	const arma::mat X, 
	const arma::vec y)
{
	arma::vec beta = X.t() * y; // lapack records answ here
	arma::mat XtX = X.t() * X;
	//
	int n = X.n_cols;
	int nrhs = 1; // one column on the rhs
	std::vector<int> ipiv(n);
	int info = 0;

	dgesv_(
		&n, &nrhs, XtX.memptr(),
		&n, ipiv.data(), beta.memptr(),
		&n, &info
	);
	return beta;
}

// [[Rcpp::export]]
arma::vec glm_inv_fit(
	const arma::mat X, 
	const arma::vec y)
{
	arma::mat XtXinv ;
	XtXinv = arma::inv_sympd(X.t() * X);
	return XtXinv * X.t() * y;
}

// potentially this class wins me little here...
// class GLM{
// public:
// 	void GLM(
// 		Rcpp::NumericMatrix X,
// 		Rcpp::NumericVector y,
// 	)
// 	:y_(Rcpp::as<arma::vec>y)
// 	 X_(Rcpp::as<arma::mat>X)
// 	{
// 		n_pred_ = X_.n_cols;
// 		n_obs_ = X_.n_rows;
// 	}

// 	arma::vec predict(
// 		const arma::mat& X
// 	) const { 
// 		return X * beta_ + b_;
// 	}

// 	double mse(
// 		const arma::mat& Xobs, const arma::vec& ytr
// 	) const {
// 		return arma::mean(arma::square(
// 			predict(Xobs) - ytr
// 		));
// 	}

// 	arma::vec lse_fit(){
// 		beta_ = X_.t() * y_; // lapack will record answer here
// 		XtX = X_.t() * X_;

// 		int n = n_pred_;
// 		int nrhs = n_obs_;
// 		std::vector<int> ipiv(n);

// 		dgesv_(
// 			&n, &nrhs, XtX.memptr(),
// 			&n, ipiv.data(), beta_.memptr(),
// 			&n, &info
// 		)

// 		return beta_; // lapack saved output here
// 	}

// private:
// 	arma::mat X_; // predictors
// 	arma::vec y_; // observations
// 	arma::mat beta_; // linear coefficients
// 	arma::vec b_; // offsets

// 	int n_pred_;
// 	int n_obs_;
// }