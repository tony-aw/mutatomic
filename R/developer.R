#' Exposed functions for Package developers
#'
#' @description
#' Functions for developers. \cr
#' The functions in this list should NOT be called by regular users. \cr
#' They are only to be used inside packages. \cr
#' \cr
#' 
#' 
#' @details
#' `.internal_set_ma()`
#' sets an object to class 'mutatomic' by reference. \cr
#' 
#' @param x atomic object
#' 
#' @return
#' Returns: VOID. This function modifies the object by reference. \cr
#' Do NOT use assignment like `x <- .internal_set_ma(x, ...)`. \cr
#' Since this function returns void, you'll just get `NULL`. \cr \cr
#' 
#' @example inst/examples/developer.R
#' 


#' @rdname developer
#' @export
address <- function(x) {
  .rcpp_address(x)
}

#' @rdname developer
#' @export
.internal_set_ma <- function(x) {
  if(identical(parent.frame(n = 1L), globalenv())) {
    stop("DO NOT call this function!!!")
  }
  if(!couldb.mutatomic(x)) {
    stop("not atomic or not convertible")
  }
  

  if(!inherits(x, "mutatomic")) {
    newclass <- c("mutatomic", .internal_sane_class(x))
  }
  else {
    newclass <- class(x)
  }
  
  .rcpp_set_ma(x, newclass)
  
  return(invisible(NULL))
}



