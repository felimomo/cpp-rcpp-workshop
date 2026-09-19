# Some GLM model fits on C++

In this repo I'll workshop my skills in C++ and the C++/R boundary (Rcpp) by fitting a GLM 
to insurance claim data from the French Motor TPL dataset: 

https://www.kaggle.com/datasets/karansarpal/fremtpl2-french-motor-tpl-insurance-claims

I previously ran some model fit experiments in Python (statsmodels/pymer4) for this dataset 
over at:

https://github.com/felimomo/fremtpl2-insurance-claims-prediction/tree/main

The point here is to reimplement a basic model fitting algorithm using the C++ linear algebra ecosystem
(Armadillo + calling functionalities from LAPACK, OpenBLAS).
As a personal project, I'm using it to better understand the "lay of the land" for statistical and numerical
calculations in C++ as a backend called from R.

## Reproduce

Spin up the environment with [conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html):

```
chmod +x env/create-env.sh
./env/create-env.sh
conda activate insurefit && source env/env-vars.sh 
```
