#!/usr/bin/env bash
set -euo pipefail

: "${CONDA_PREFIX:?Not in a conda env — run 'conda activate insurefit' first}"

CXX_PATH=$(R CMD config CXX)
FC_PATH=$(R CMD config FC)
echo "R:   $(which R)"
echo "CXX: $CXX_PATH"
echo "FC:  $FC_PATH"

if [[ "$CXX_PATH" != *"$CONDA_PREFIX"* ]]; then
  echo "FAIL: R's C++ compiler is outside the conda env — ABI mismatch risk." >&2
  exit 1
fi

Rscript "$(dirname "$0")/verify-install.R"
echo "OK: toolchain consistent."