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
#' `.internal_ma_set_DimsAndNames()`
#' sets the dimensions and (dim)names of a 'mutatomic' object by reference. \cr
#' 
#' @param x atomic object
#' @param names `NULL` or a character vector of the same length as `x`,
#' giving the flat names.
#' @param dim `NULL` or an integer vector giving the dimensions of `x`. \cr
#' Note that it must hold that `prod(dim(x)) == length(x)`.
#' @param dimnames `NULL` or a list of `dimnames``.`
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
.internal_set_ma <- function(x) {
  if(identical(parent.frame(n = 1L), globalenv())) {
    stop("DO NOT call this function!!!")
  }
  if(!couldb.mutatomic(x)) {
    stop("not atomic or not convertible")
  }
  
  if(!"mutatomic" %in% class(x)) {
    data.table::setattr(x, "class", c("mutatomic", class(x)))
  }
  
  data.table::setattr(x, "serial", .C_serial(x))
  
  return(invisible(NULL))
}


#' @rdname developer
#' @export
.internal_ma_set_DimsAndNames <- function(x, names = NULL, dim = NULL, dimnames = NULL) {
  
  if(identical(parent.frame(n = 1L), globalenv())) {
    stop("DO NOT call this function!!!")
  }
  
  # set dims, names, and dimnames of a mutatomic object BY REFERENCE
  
  if(!is.mutatomic(x)) {
    stop("not mutatomic")
  }
  
  
  data.table::setattr(x, "dim", data.table::copy(dim))

  dimnames <- data.table::copy(dimnames) # protection against pass-by-reference
  data.table::setattr(x, "dimnames", NULL)
  data.table::setattr(x, "dimnames", dimnames)

  names <- data.table::copy(names) # protection against pass-by-reference
  data.table::setattr(x, "names", NULL)
  data.table::setattr(x, "names", names)

}

