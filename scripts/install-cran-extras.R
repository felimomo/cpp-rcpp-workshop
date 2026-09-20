#!/usr/bin/env Rscript
# Packages not available on conda-forge. 
# Run once after creating the env.

prefix <- Sys.getenv("CONDA_PREFIX")
if (!nzchar(prefix)) stop("Activate the insurefit env first.")

lib <- file.path(prefix, "lib", "R", "library")
install.packages("bench", lib = lib, repos = "https://cloud.r-project.org")