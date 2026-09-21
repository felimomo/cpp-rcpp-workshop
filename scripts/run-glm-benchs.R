Rcpp::sourceCpp(here::here("src", "glm.cpp"))
library(dplyr)

run_one <- function(n_obs, n_pred, data_sd = 1.0, n_eval = 100) {
  beta   <- rnorm(n_pred)
  X_tr   <- matrix(rnorm(n_obs * n_pred),   nrow = n_obs,  ncol = n_pred)
  y_tr   <- as.vector(X_tr %*% beta) + rnorm(n_obs, sd = data_sd)
  X_eval <- matrix(rnorm(n_eval * n_pred), nrow = n_eval, ncol = n_pred)
  y_eval <- as.vector(X_eval %*% beta) + rnorm(n_eval, sd = data_sd)

  fits <- list(
    dgesv = as.vector(glm_dgesv_fit(X_tr, y_tr)),
    inv   = as.vector(glm_inv_fit(X_tr, y_tr)),
    qr    = as.vector(qr.solve(X_tr, y_tr))
  )

  timings <- bench::mark(
    dgesv = glm_dgesv_fit(X_tr, y_tr),
    inv   = glm_inv_fit(X_tr, y_tr),
    qr    = qr.solve(X_tr, y_tr),
    check = FALSE
  )

  tibble(
    n_obs    = n_obs,
    n_pred   = n_pred,
    method   = as.character(timings$expression),
    median_s = as.numeric(timings$median),
    mem_mb   = as.numeric(timings$mem_alloc) / 1e6,
    mse      = vapply(fits[as.character(timings$expression)],
                      function(b) mean((y_eval - as.vector(X_eval %*% b))^2),
                      numeric(1)),
    max_dev_qr = vapply(fits[as.character(timings$expression)],
                        function(b) max(abs(b - fits$qr)), numeric(1))
  )
}

grid <- expand.grid(n_obs  = c(1000, 2000, 3000, 4000),
                    n_pred = c(200, 500, 900, 1500, 1900, 2500, 2900, 3500, 3900))
grid <- subset(grid, n_pred < n_obs)          # need n > p

results <- purrr::pmap_dfr(grid, run_one)
print(results, n = Inf)
write.csv(results, here::here("notes", "glm-benchmarks.csv"), row.names = FALSE)