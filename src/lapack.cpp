#include <RcppArmadillo.h>
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

  if (info > 0) Rcpp::stop(
    "Matrix exactly singular at U[%d,%d]", 
    info, info
  );
  if (info < 0) Rcpp::stop(
    "Illegal argument %d", 
    -info
  );
  return bcopy; // sol stored here
}


// dgesv solves linear systems for symmetric A:
//
// Ax = b
//
// by first factorizing A = L L^T (Cholesky), and
// then doing two triangular solves O(n2)

// Benchmark runtime savings from sequential solves
// with the same A matrix if this split is done
// intentionally.

// This is relevant if the matrix b is significantly
// large, larger than cache. There, copying from RAM
// will dominate runtime.
//
// Solution: split b into smaller chunks,
//           single Cholesky factorization of A, 
//           triangular solution for each chunk of b


// cholesky factorization of matrix a
extern "C" {
  void dpotrf_(
    const char* uplo, 
    const int* n, 
    double* a, 
    const int* lda,
    int* info);
}

// solves system Ax = b for a cholesky-factorized A
extern "C" {
  void dpotrs_(
    const char* uplo, 
    const int* n, 
    const int* nrhs, 
    double* a, 
    const int* lda,
    double* b, 
    const int* ldb, 
    int* info);
}

// take the discussion above to the extreme:
// batch size = 1
// [[Rcpp::export]]
Rcpp::NumericVector solve_lapack_batch(
  Rcpp::NumericMatrix A_SymUp, // upper triang of 
  Rcpp::NumericMatrix b)       // symmetric matrix
{
  Rcpp::NumericMatrix Acopy = Rcpp::clone(A_SymUp);
  Rcpp::NumericVector bcopy = Rcpp::clone(b);
  
  int n = A.nrow();
  char uplo = 'U';
  int info = 0;

  dpotrf_(&uplo, &n, Acopy.begin(), &n, &info);



}


// Archit.: A CholSolver that has a cholesky factor
//          attribute and a 'solve' method. 
//
//          Cholesky is computed once, and attribute
//          survives between method calls.

// in R:
//    s <- new(CholSolver, XtX_upper)
//    X <- s$solve_batch(B)
class CholSolver {
public:
  CholSolver(
    const Rcpp::NumericMatrix& A_upper // R-mtrx in
  ) // initialize attribute (L_) which is arma::mat
  :L_(Rcpp::as<arma::mat>(A_upper))
  { 
    // constructor, uses matrix A>0 to be factorized
    
    // setting up LAPACK args 
    n_ = A_upper.nrow();
    uplo_ = 'U'; // attribute
    int info = 0;
    int n = n_
    int uplo = uplo

    // cholesky factor overwritten in R_
    dpotrf_(
      &uplo, &n, 
      const_cast<double*>(L_.memptr()), // lapack arg
      &n, &info);

    if (info > 0){
      Rcpp::stop(
        "Matrix is not PSD (U[%d,%d] = 0)", 
        info, info
      );
    }
    if (info < 0){
      Rcpp::stop("Illegal argument %d", -info);
    }
  }
  arma::mat solve_batch(
    const Rcpp::NumericMatrix& B
  ) const {
    // solves equations AX=B for a batch of columns B
    
    arma::mat Barma = Rcpp::as<arma::mat>(B);
    nrhs = B.ncol()
    int info = 0
    int n = n_
    int uplo = uplo_

    // LAPACK call. Solves in-place in Barma.
    dpotrs_(
      &uplo, &n, &nrhs, 
      const_cast<double*>(L_.memptr()), 
      &n, 
      const_cast<double*>(Barma.memptr()), 
      &n, &info
    )
    if (info < 0){
      Rcpp::stop(
        "dpotrs: illegal argument %d", -info);
    }
    return Barma;
  }
private:
  arma::mat L_; // chol. factor
  char uplo_;
  int n_;
};

// boilerplate to expose the class to R
RCPP_MODULE(chol_module) {
  Rcpp::class_<CholSolver>("CholSolver")
    .constructor<Rcpp::NumericMatrix>()
    .method("solve_batch", &CholSolver::solve_batch);
}
