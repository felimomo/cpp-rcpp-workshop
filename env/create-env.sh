#!/usr/bin/env bash
set -euo pipefail
conda env create -f "$(dirname "$0")/environment.yml"
echo "Created. Now: conda activate workshop && source env/env-vars.sh"