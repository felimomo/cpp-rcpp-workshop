#include <ArmadilloCpp.h>

class GLM{
public:
	void GLM(
		Rcpp::NumericMatrix X,
		Rcpp::NumericVector y,
	)
	:y_(Rcpp::as<arma::vec>y)
	 X_(Rcpp::as<arma::mat>X)
	{
		n_pred_ = X_.n_cols
		n_obs_ = X_.n_rows
	}
private:
	arma::mat X_; // predictors
	arma::vec y_; // observations
	arma::mat beta_; // linear coefficients
	int n_pred_;
	int n_obs_;
}