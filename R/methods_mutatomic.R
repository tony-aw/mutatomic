#' 'mutatomic' Method Extension of Generic Functions
#'
#' @description
#' This page lists the methods defined for the \link{mutatomic} class. \cr
#' For the package overview, see \link{mutatomic_help}. \cr
#'
#'
#' @param x an atomic object.
#' @param value see \link[base]{Extract}.
#' @param use.names Boolean, indicating if \link[base]{names} should be preserved.
#' @param ... method dependent arguments.
#' 
#' 
#' @returns
#' Returns, modifies, or prints a `mutatomic` object. \cr
#' \cr
#'
#'
#' @example inst/examples/class_mutatomic.R
#' 


#' @name mutatomic_methods
NULL


#' @rdname mutatomic_methods
#' @export
as.logical.mutatomic <- function(x, ...) {
  out <- as.logical(unclass(x))
  return(.mutatomic_typecast(out, x))
}


#' @rdname mutatomic_methods
#' @export
as.integer.mutatomic <- function(x, ...) {
  out <- as.integer(unclass(x))
  return(.mutatomic_typecast(out, x))
}


#' @rdname mutatomic_methods
#' @export
as.double.mutatomic <- function(x, ...) {
  out <- as.double(unclass(x))
  return(.mutatomic_typecast(out, x))
}


#' @rdname mutatomic_methods
#' @export
as.complex.mutatomic <- function(x, ...) {
  out <- as.complex(unclass(x))
  return(.mutatomic_typecast(out, x))
}


#' @rdname mutatomic_methods
#' @export
as.character.mutatomic <- function(x, ...) {
  out <- as.character(unclass(x))
  return(.mutatomic_typecast(out, x))
}


#' @rdname mutatomic_methods
#' @export
as.raw.mutatomic <- function(x, ...) {
  out <- as.raw(unclass(x))
  return(.mutatomic_typecast(out, x))
}


#' @keywords internal
#' @noRd
.mutatomic_typecast <- function(out, x) {
  if(!is.mutatomic(x)) {
    return(out)
  }
  dim(out) <- dim(x)
  dimnames(out) <- dimnames(x)
  names(out) <- names(x)
  .internal_set_ma(out)
  return(out)
}


#' @rdname mutatomic_methods
#' @export
c.mutatomic <- function(..., use.names = TRUE) {
  y <- unlist(list(...), recursive = FALSE, use.names = use.names)
  .internal_set_ma(y)
  return(y)
}



#' @rdname mutatomic_methods
#' @export
`[.mutatomic` <- function(x, ...) {
  y <- NextMethod("[")
  
  if(!inherits(y, "mutatomic")) {
    class(y) <- c("mutatomic", .internal_sane_class(y))
  }
  
  attr(y, "serial") <- .C_serial(y)
  y
}


#' @rdname mutatomic_methods
#' @export
`[<-.mutatomic` <- function(x, ..., value) {
  
  oldtype <- typeof(x)
  
  oc <- .internal_sane_class(x)
  class(x) <- NULL
  x[...] <- value
  class(x) <- oc
  
  newtype <- typeof(x)
  if(oldtype != newtype) {
    message(sprintf("coercing type from `%s` to `%s`", oldtype, newtype))
  }
  
  attr(x, "serial") <- .C_serial(x)
  x
}


#' @rdname mutatomic_methods
#' @export
format.mutatomic <- function(x, ...) {
  class(x) <- setdiff(class(x), "mutatomic")
  attr(x, "serial") <- NULL
  format(x, ...)
}


#' @rdname mutatomic_methods
#' @export
print.mutatomic <- function(x, ...) {
  class(x) <- setdiff(class(x), "mutatomic")
  attr(x, "serial") <- NULL
  print(x, ...)
  cat("mutatomic \n")
  cat(paste("typeof: ", typeof(x), "\n"))
}
