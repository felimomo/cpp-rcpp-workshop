Rcpp::sourceCpp(here::here("src", "glm.cpp"))

####
# globals
####
# note: even for modest dimensions, a large column dim
#       (n_pred) and a low condition number (n_pred almost n_obs)
#       give a big diff. in performance.
#### 
n_pred <- 1800
n_obs <- 2000
data_sd = 1.0

# synthetic data
beta <- rnorm(n_pred)
X_tr = matrix(
	rnorm(n_obs * n_pred), 
	ncol=n_pred, nrow=n_obs
)
y_tr <- as.vector(X_tr %*% beta) + rnorm(n_obs, sd=data_sd)

n_eval = 100
X_eval = matrix(
	rnorm(n_eval * n_pred), 
	ncol=n_pred, nrow=n_eval
)
y_eval <- as.vector(X_eval %*% beta) + rnorm(n_eval, sd=data_sd)

# fit model the two ways
bench::mark(
	gsev_beta = {gsev_beta<- glm_dgesv_fit(X_tr, y_tr)},
	inv_beta  = {inv_beta <- glm_inv_fit(X_tr, y_tr)},
	qr_beta   = {qr_beta  <- qr.solve(X_tr, y_tr)},
	check     = FALSE # so benchmark is ok 
	                  # with different results
)

y_gsev <- X_eval %*% gsev_beta
y_inv <- X_eval %*% inv_beta
y_qr <- X_eval %*% qr_beta

mse_gsev <- mean((y_eval - y_gsev)^2)
mse_inv <- mean((y_eval - y_inv)^2)
mse_qr <- mean((y_eval - y_qr)^2)

cat(sprintf(
	"MSE (dgesv):    %.6e\nMSE (inv):      %.6e\nMSE (qr.solve): %.6e\n rel. qr-gsev:   %.3e\n",
   mse_gsev, mse_inv, mse_qr, abs(mse_gsev - mse_qr) / mse_gsev))
