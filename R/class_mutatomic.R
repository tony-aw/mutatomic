#' A Class of Mutable Atomic Objects
#'
#' @description
#' For the package overview, see \link{mutatomic_help}. \cr
#' \cr
#' The `mutatomic` class is a mutable version of atomic classes. \cr
#' It works exactly the same in all aspects as regular atomic classes. \cr
#' There is only one real difference: \cr
#' Pass-by-reference functions in (primarily) the 'squarebrackets' and 'broadcast' packages
#' only accept atomic objects when they are of class `mutatomic`,
#' for greater safety. \cr
#' In all other aspects, `mutatomic` objects are the same as R's regular atomic objects,
#' including the behaviour of the `[<-` operator . \cr
#' \cr
#' Exposed functions (beside the S3 methods):
#' 
#'  * `mutatomic()`: create a `mutatomic` object from given data.
#'  * `couldb.mutatomic()`: checks if an object could become `mutatomic`. \cr
#' An objects can become `mutatomic` if it is one of the following types: \cr
#' \link{logical}, \link{integer}, \link{double}, \link{character}, \link{complex}, \link{raw}. \cr
#' Factors can never be `mutatomic`.
#'  * `typecast.mutatomic()` type-casts and possibly reshapes a (mutable) atomic object,
#'  and returns a `mutatomic` object. \cr
#'  Does not preserve dimension names if dimensions are changed. \cr
#'
#'
#'
#' @param x an atomic object.
#' @param data atomic vector giving data to fill the `mutatomic` object.
#' @param value see \link[base]{Extract}.
#' @param names,dim,dimnames see \link[stats]{setNames} and \link[base]{array}.
#' @param type a string giving the type; see \link[base]{typeof}.
#' @param dims integer vector, giving the new dimensions.
#' @param use.names Boolean, indicating if \link[base]{names} should be preserved.
#' @param ... method dependent arguments.
#' 
#' 
#' @section Warning: 
#' Always use
#' the exported functions given by 'mutatomic'
#' to create a `mutatomic` object,
#' as they make necessary checks. \cr
#' Circumventing these checks may break things! \cr
#' \cr
#' 
#' 
#' @returns
#' For `mutatomic()`, `as.mutatomic()`, `typecast.mutatomic()`: \cr
#' Returns a `mutatomic` object. \cr
#' \cr
#' For `is.mutatomic()`: \cr
#' Returns `TRUE` if the object is `mutatomic`,
#' and returns `FALSE` otherwise. \cr
#' \cr
#' For `couldb.mutatomic()`: \cr
#' Returns `TRUE` if the object is one of the following types: \cr
#' \link{logical}, \link{integer}, \link{double}, \link{character}, \link{complex}, \link{raw}. \cr
#' Returns `FALSE` otherwise. \cr \cr
#'
#'
#' @example inst/examples/class_mutatomic.R
#' 


#' @name mutatomic_class
NULL



#' @rdname mutatomic_class
#' @export
mutatomic <- function(data, names = NULL, dim = NULL, dimnames = NULL) {
  
  if(!couldb.mutatomic(data)) {
    stop("non-atomic or non-convertible data given")
  }
  
  y <- as.vector(data)
  dim(y) <- dim
  dimnames(y) <- dimnames
  names(y) <- names
  
  if(.C_is_altrep(y)) {
    y <- .ma_materialize(y)
  }
  
  .internal_set_ma(y)
  
  return(y)
  
}

#' @rdname mutatomic_class
#' @export
as.mutatomic <- function(x, ...) {
  UseMethod("as.mutatomic", x)
}

#' @rdname mutatomic_class
#' @export
as.mutatomic.default <- function(x, ...) {
  if(!couldb.mutatomic(x)) {
    stop("not atomic or not convertible")
  }
  if(is.mutatomic(x)) {
    return(x)
  }
  
  y <- x
  if(.C_is_altrep(y)) {
    return(.ma_materialize(y))
  }
  else {
    y <- data.table::copy(y)
  }
  
  
  .internal_set_ma(y)
  .internal_ma_set_DimsAndNames(y, names(x), dim(x), dimnames(x))
  
  return(y)
  
}

#' @keywords internal
#' @noRd
.ma_materialize <- function(x) {
  
  y <- vector(typeof(x), length(x))
  .rcpp_set_all_atomic(y, rp = x)
  mostattributes(y) <- attributes(x)
  
  .internal_set_ma(y)
  .internal_ma_set_DimsAndNames(y, names(x), dim(x), dimnames(x))
  
  return(y)
}



#' @rdname mutatomic_class
#' @export
is.mutatomic <- function(x) {
  
  if(!couldb.mutatomic(x)) return(FALSE)
  check_protected <- .C_anyaddress(
    .pkgenv_mutatomic[["protected"]],
    .rcpp_address(x)
  )
  if(check_protected) return(FALSE)
  
  # Note: cannot check for altrep,
  # since things like logical vectors are stored as altrep during package testing
  
  check <- .rcpp_is_ma(x)
  return(check)
  
}


#' @rdname mutatomic_class
#' @export
couldb.mutatomic <- function(x) {
  check1 <- is.logical(x) || is.integer(x) || is.double(x) || is.character(x) || is.complex(x) || is.raw(x)
  check2 <- !is.null(x) && !is.factor(x)
  return(
    check1 && check2
  )
}


#' @rdname mutatomic_class
#' @export
typecast.mutatomic <- function(x, type = typeof(x), dims = dim(x)) {
  
  if(length(x) != prod(dims)) {
    stop("dimension product does not match the length of object")
  }
  
  # set type:
  if(type == "logical") {
    y <- as.logical(x)
  }
  else if(type == "integer") {
    y <- as.integer(x)
  }
  else if(type == "double") {
    y <- as.double(x)
  }
  else if(type == "character") {
    y <- as.character(x)
  }
  else if(type == "complex") {
    y <- as.complex(x)
  }
  else if(type == "raw") {
    y <- as.raw(x)
  }
  else {
    stop("unsupported type")
  }
  
  # set dimensions:
  if(!is.null(dims)) {
    if(length(x) == prod(dims)) {
      data.table::setattr(y, "dim", dims)
    }
  }
  
  # convert:
  .internal_set_ma(y)
  
  # set names:
  if(!is.null(names(x))) {
    nms <- data.table::copy(names(x)) # protection against pass-by-reference
    data.table::setattr(y, "names", NULL)
    data.table::setattr(y, "names", nms)
  }
  if(!is.null(dimnames(x)) && all(dim(x) == dim(y))) {
    nms <- data.table::copy(dimnames(y)) # protection against pass-by-reference
    data.table::setattr(y, "dimnames", NULL)
    data.table::setattr(y, "dimnames", nms)
  }
  
  return(y)
  
}




#' @rdname mutatomic_class
#' @export
c.mutatomic <- function(..., use.names = TRUE) {
  y <- unlist(list(...), recursive = FALSE, use.names = use.names)
  .internal_set_ma(y)
  return(y)
}



#' @rdname mutatomic_class
#' @export
`[.mutatomic` <- function(x, ...) {
  y <- NextMethod("[")
  
  if(!inherits(y, "mutatomic")) {
    class(y) <- c("mutatomic", class(y))
  }
  
  attr(y, "serial") <- .C_serial(y)
  y
}


#' @rdname mutatomic_class
#' @export
`[<-.mutatomic` <- function(x, ..., value) {
  
  oldtype <- typeof(x)
  
  oc <- oldClass(x)
  class(x) <- NULL
  x[...] <- value
  class(x) <- oc
  
  newtype <- typeof(x)
  if(oldtype != newtype) {
    message(sprintf("coercing type from `%s` to `%s`", oldtype, newtype))
    attr(x, "serial") <- .C_serial(x)
  }
  
  x
}


#' @rdname mutatomic_class
#' @export
format.mutatomic <- function(x, ...) {
  class(x) <- setdiff(class(x), "mutatomic")
  attr(x, "serial") <- NULL
  format(x, ...)
}


#' @rdname mutatomic_class
#' @export
print.mutatomic <- function(x, ...) {
  class(x) <- setdiff(class(x), "mutatomic")
  attr(x, "serial") <- NULL
  print(x, ...)
  cat("mutatomic \n")
  cat(paste("typeof: ", typeof(x), "\n"))
}
