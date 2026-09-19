#!/usr/bin/env Rscript

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