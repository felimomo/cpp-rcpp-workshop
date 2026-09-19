#!/usr/bin/env Rscript

prefix <- Sys.getenv("CONDA_PREFIX")
if (!nzchar(prefix) || !startsWith(normalizePath(R.home()), normalizePath(prefix))) {
  stop("Not running under the insurefit conda env. Run: conda activate insurefit")
}

path <- path.expand("~/insurefit")

usethis::create_package(path, open = FALSE)

usethis::with_project(path, {
  usethis::use_rcpp_armadillo()
  usethis::use_testthat()
  usethis::use_git()

  writeLines(
    c("PKG_LIBS = $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)",
      "PKG_CXXFLAGS = -O2"),
    "src/Makevars"
  )
  usethis::use_build_ignore("scripts")
  write("src/*.o\nsrc/*.so\n", ".gitignore", append = TRUE)
})

cat("Scaffold complete:", path, "\n")