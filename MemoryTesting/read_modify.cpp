// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
#include <cstdlib>
#include <new>

//
// Placing this on its own directory outside src/
// in case I want to ship this into a package format
// (there I wouldn't want this messing with the
// new and delete operations)
//

// allocation counter 
static std::size_t g_alloc = 0;

// override new to keep track of memory allocation
void* operator new(std::size_t n) {
  g_alloc += n;
  if (void* p = std::malloc(n)) return p;
  throw std::bad_alloc();
}

// need to override delete too to avoid crashing
void operator delete(void* p) noexcept { std::free(p); }
void operator delete(void* p, std::size_t) noexcept { std::free(p); }

// [[Rcpp::export]]
double alloc_reset() { 
  double v = g_alloc; 
  g_alloc = 0; 
  return v; 
}

// [[Rcpp::export]]
double alloc_mb() { return g_alloc / 1e6; }

// Two similar-looking Rcpp functions.

// making an actual data copy
// [[Rcpp::export]]
double cpp_copy(
  const Rcpp::NumericMatrix& Mr
) {
  arma::mat M = Rcpp::as<arma::mat>(Mr);   
  return arma::accu(M);
}

// Making a view-only copy (view R's memory)
//   => M.memptr() IS Mr.begin(). 
// note: need copy_aux_mem = false below
// [[Rcpp::export]]
double cpp_view(
  const Rcpp::NumericMatrix& Mr
) {
  const arma::mat M(const_cast<double*>(
    Mr.begin()), 
    Mr.nrow(), 
    Mr.ncol(),
    false,       // copy_aux_mem
    true         // strict (pin version to R buffer: 
);               // can't resize later in the function)

  return arma::accu(M);
}