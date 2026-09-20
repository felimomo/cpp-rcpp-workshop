#include <ArmadilloCpp.h>

// lapack interface
extern "C" {
  void dgesv_(
    const int* n,   const int* nrhs, 
    double* a,      const int* lda,
    int* ipiv,      double* b, 
    const int* ldb, int* info);
}

class GLM{
public:
	void GLM(
		Rcpp::NumericMatrix X,
		Rcpp::NumericVector y,
	)
	:y_(Rcpp::as<arma::vec>y)
	 X_(Rcpp::as<arma::mat>X)
	{
		n_pred_ = X_.n_cols;
		n_obs_ = X_.n_rows;
	}

	arma::vec predict(
		const arma::mat& X
	) const { 
		return X * beta_ + b_;
	}

	double mse(
		const arma::mat& Xobs, const arma::vec& ytr
	) const {
		return arma::mean(arma::square(
			predict(Xobs) - ytr
		));
	}

	void fit(){
		XtY = X_.t() * y_
		XtX = X_.t() * X_

		int n = n_pred_
		int nrhs = n_obs_
		std::vector<int> ipiv(n);

		dgesv_(
			&n, &nrhs, XtX.memptr(),
			&n, ipiv.data(), &XtY,
			&n, &info
		)

		return XtY; // lapack saved output here
	}

private:
	arma::mat X_; // predictors
	arma::vec y_; // observations
	arma::mat beta_; // linear coefficients
	arma::vec b_; // offsets

	int n_pred_;
	int n_obs_;
}