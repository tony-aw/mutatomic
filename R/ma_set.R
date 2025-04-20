#' Example Pass-By-Reference Function
#'
#' @description
#' The `ma_set()` function modifies a subset of a \link{mutatomic} object by reference. \cr
#' It is an example function, used to illustrate various examples in the help pages. \cr
#' For full pass-by-reference functionality,
#' please see - for example - the 'squarebrackets' package. \cr \cr
#' 
#'
#' @param x a \bold{mutatomic} vector (also works on arrays). \cr
#' @param i a vector of strictly positive numbers, providing vector indices. \cr
#' @param rp the replacement value. \cr
#' Must be of the same type as `x`, and the same length or lenght of 1. \cr \cr
#' 
#' 
#' 
#' 
#' @returns
#' Returns: VOID. This method modifies the object by reference. \cr
#' Do not use assignments like `x <- ma_set(x, ...)`. \cr
#' Since this function returns void, you'll just get `NULL`. \cr \cr
#'
#'
#' @example inst/examples/ma_set.R
#' 



#' @rdname ma_set
#' @export
ma_set <- function(
    x, i, rp
) {
  
  stopifnot_ma_safe2mutate(substitute(x), parent.frame(n = 1), sys.call())
  if(!is.numeric(i)) {
    stop("`i` must be numeric")
  }
  if(.C_any_badindx(i, length(x))) {
    stop("`i` out of bounds")
  }
  n.i <- length(i)
  if(n.i == 0L) {
    return(invisible(NULL))
  }
  .check_rp_atomic(rp, n.i, sys.call())
  
  .rcpp_set_vind(x, i, rp, sys.call())
  return(invisible(NULL))
}


#' @keywords internal
#' @noRd
.rcpp_set_vind <- function(x, ind, rp, abortcall) {
  
  rp <- .internal_coerce_rp(x, rp, abortcall)
  
  if(length(x) < (2^31 - 1)) {
    .rcpp_set_vind_32_atomic(x, as.integer(ind - 1L), rp)
    return(invisible(NULL))
  }
  else {
    .rcpp_set_vind_64_atomic(x, as.double(ind - 1), rp)
    return(invisible(NULL))
  }
}

