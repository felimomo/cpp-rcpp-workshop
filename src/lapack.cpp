#include <Rcpp.h>
// interface to call LAPACK's dgesv_ ABI
extern "C" {
  void dgesv_(
    const int* n, 
    const int* nrhs, 
    double* a, 
    const int* lda,
    int* ipiv, 
    double* b, 
    const int* ldb, 
    int* info);
}

// [[Rcpp::export]]
Rcpp::NumericVector solve_lapack(
  Rcpp::NumericMatrix A, 
  Rcpp::NumericVector b)
{
  // calls dgesv to solve Ax = b
  int n = A.nrow(); // A is n x n
  int nrhs = 1;         // b and x are n x nrhs
  int info = 0;

  // copies needed: dgesv A & b in-place when doing LU
  //                (recall, A & b are R matrices which
  //                we dont want to modify inadvertently)
  Rcpp::NumericMatrix Acopy = Rcpp::clone(A);
  Rcpp::NumericVector bcopy = Rcpp::clone(b);

  // "pivot vector:"
  // target memory location to store row permutations
  // while doing LU decomp.
  //
  // this is internal to the algorithm, but Fortran77
  // had no dynamic memory allocation, so any needed
  // memory goes as an argument.
  std::vector<int> ipiv(n);

  // note: all args are pointers (methods like .begin(),
  //       etc return pointers)
  dgesv_(&n, &nrhs, Acopy.begin(), &n, ipiv.data(), bcopy.begin(), &n, &info);

  if (info > 0) Rcpp::stop("Matrix exactly singular at U[%d,%d]", info, info);
  if (info < 0) Rcpp::stop("Illegal argument %d", -info);
  return bcopy;
}