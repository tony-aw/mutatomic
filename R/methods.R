
#' @export
as.logical.mutatomic <- function(x, ...) {
  out <- as.logical(unclass(x))
  return(.mutatomic_typecast(out, x))
}



#' @export
as.integer.mutatomic <- function(x, ...) {
  out <- as.integer(unclass(x))
  return(.mutatomic_typecast(out, x))
}



#' @export
as.double.mutatomic <- function(x, ...) {
  out <- as.double(unclass(x))
  return(.mutatomic_typecast(out, x))
}



#' @export
as.complex.mutatomic <- function(x, ...) {
  out <- as.complex(unclass(x))
  return(.mutatomic_typecast(out, x))
}



#' @export
as.character.mutatomic <- function(x, ...) {
  out <- as.character(unclass(x))
  return(.mutatomic_typecast(out, x))
}



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


#' @export
c.mutatomic <- function(..., use.names = TRUE) {
  y <- unlist(list(...), recursive = FALSE, use.names = use.names)
  .internal_set_ma(y)
  return(y)
}




#' @export
`[.mutatomic` <- function(x, ...) {
  
  if(!is.mutatomic(x)) {
    stop("malformed mutatomic")
  }
  y <- NextMethod("[")
  
  if(!inherits(y, "mutatomic")) {
    class(y) <- c("mutatomic", .internal_sane_class(y))
  }
  
  attr(y, "serial") <- .C_serial(y)
  y
}

#' @export
`[[.mutatomic` <- function(x, ...) {
  
  if(!is.mutatomic(x)) {
    stop("malformed mutatomic")
  }
  y <- NextMethod("[[")
  
  if(!inherits(y, "mutatomic")) {
    class(y) <- c("mutatomic", .internal_sane_class(y))
  }
  
  attr(y, "serial") <- .C_serial(y)
  y
}


#' @export
`[<-.mutatomic` <- function(x, ..., value) {
  
  if(!is.mutatomic(x)) {
    stop("malformed mutatomic")
  }
  
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

#' @export
`[[<-.mutatomic` <- function(x, ..., value) {
  
  if(!is.mutatomic(x)) {
    stop("malformed mutatomic")
  }
  
  oldtype <- typeof(x)
  
  oc <- .internal_sane_class(x)
  class(x) <- NULL
  x[[...]] <- value
  class(x) <- oc
  
  newtype <- typeof(x)
  if(oldtype != newtype) {
    message(sprintf("coercing type from `%s` to `%s`", oldtype, newtype))
  }
  
  attr(x, "serial") <- .C_serial(x)
  x
}


#' @export
format.mutatomic <- function(x, ...) {
  
  if(!is.mutatomic(x)) {
    stop("malformed mutatomic")
  }
  
  class(x) <- setdiff(class(x), "mutatomic")
  attr(x, "serial") <- NULL
  format(x, ...)
}



#' @export
print.mutatomic <- function(x, ...) {
  
  if(!is.mutatomic(x)) {
    stop("malformed mutatomic")
  }
  
  class(x) <- setdiff(class(x), "mutatomic")
  attr(x, "serial") <- NULL
  print(x, ...)
  cat("mutatomic \n")
  cat(paste("typeof: ", typeof(x), "\n"))
}


