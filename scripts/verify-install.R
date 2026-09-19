cat(R.version.string, "\n")

blas <- extSoftVersion()[["BLAS"]]
blas_real <- normalizePath(blas, mustWork = FALSE)
cat("BLAS (reported, potentially symlinked): ", blas, "\n", sep = "")
cat("BLAS (resolved):    ", blas_real, "\n", sep = "")

prefix <- Sys.getenv("CONDA_PREFIX")
if (nzchar(prefix) && !startsWith(blas_real, normalizePath(prefix))) {
  stop("BLAS resolves outside the conda env: ", blas_real)
}
if (!grepl("openblas", blas_real, ignore.case = TRUE)) {
  warning("Not OpenBLAS — benchmarks will not be representative.")
}

stopifnot(Rcpp::evalCpp("2 + 2") == 4)
cat("Rcpp compile/link/load: OK\n")