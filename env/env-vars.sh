# This file should be sourced, not executed.
# See instructions in README.

if [[ -z "${CONDA_PREFIX:-}" ]]; then
  echo "WARN: no conda env active — run 'conda activate insurefit' first" >&2
fi

# Parallel compilation
export MAKEFLAGS="-j4"

# Single-threaded BLAS (reproducible benchmarks).
export OPENBLAS_NUM_THREADS=1
export OMP_NUM_THREADS=1

# Keep CRAN-installed packages inside the conda env
export R_LIBS_USER="${CONDA_PREFIX}/lib/R/library"