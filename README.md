# C++ Rcpp workshop

## Summary

Memory, runtime and accuracy benchmarks on a C++ backend called from R with Rcpp, with LAPACK ABI calls.

## Motivation

In this repo I'll workshop my skills in C++ and the C++/R boundary (Rcpp), and specifically on how to use
the LAPACK ABI. I'll do performance benchmarks that show where runtime and memory savings can be relevant.

As a personal project, I'm using it to better understand the "lay of the land" for statistical and numerical
calculations in C++ as a backend called from R.
The toolset I'm using is: Armadillo, LAPACK ABI, Rcpp.

A second stage of the project would involve writing some basic statistical inference algorithms "from scratch"
using the low-level functionalities provided by LAPACK. A good test dataset for this is the
[French Motors TPL insurance claim dataset](https://www.kaggle.com/datasets/karansarpal/fremtpl2-french-motor-tpl-insurance-claims).

I previously worked on inference for this dataset over at:

https://github.com/felimomo/fremtpl2-insurance-claims-prediction/tree/main

## GLM benchmarks

The script `scripts/run-glm-bench.R` analyzes the runtime, memory usage and accuracy of different fitting algorithms for a general linear model.
These results are stored in `notes/glm-benchmarks.csv` and plotted using `notes/bench-plots`.
The plots can be found at [`plots/`](https://github.com/felimomo/cpp-rcpp-workshop/tree/main/plots).

## Reproduce

### Setup

Spin up the environment with [conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html):

```
chmod +x env/create-env.sh
./env/create-env.sh
conda activate insurefit && source env/env-vars.sh 
Rscript scripts/install-cran-extras.R
```

### Run

Basic playground testing the R<>Cpp boundary (calling C++ functions with Armadillo and Rcpp types from an R script).
Run the R script yourself once the setup is done:
```
Rscript scripts/playground.R
```

Benchmarking runtime and memory usage for functions on Armadillo matrices:
```
Rscript scripts/arma_benchmark.R
```

Calling and benchmarking a LAPACK algorithm
(solving a system of linear equations):
```
Rscript scripts/lapack-calls.R
```

Benchmarking C++/R methods to fit
a general linear model:
```
Rscript scripts/glm-fit.R
```

Run grid benchmarks for a general linear model fit 
and generate csv data:
```
Rscript scripts/run-glm-benchs.R
```
