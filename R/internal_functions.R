

#' @keywords internal
#' @noRd
.check_rp_atomic <- function(rp, sslength, abortcall) {
  n.rp <- length(rp)
  if(!is.atomic(rp)) {
    stop(simpleError("replacement must be atomic", call = abortcall))
  }
  if(n.rp != sslength && n.rp != 1L) {
    stop(simpleError("recycling not allowed", call = abortcall))
  }
  # if(typeof(rp) != sstype) stop("type coercion not allowed")
}





#' @keywords internal
#' @noRd
.internal_coerce_rp <- function(x, rp, abortcall) {
  rp_na <- length(rp) == 1L && is.na(rp)
  if(!rp_na && typeof(x) != typeof(rp)) {
    message(sprintf("coercing replacement to %s", typeof(x)))
    if(is.logical(x)) rp <- as.logical(rp)
    else if(is.integer(x)) rp <- as.integer(rp)
    else if(is.double(x)) rp <- as.double(rp)
    else if(is.complex(x)) rp <- as.complex(rp)
    else if(is.character(x)) rp <- as.character(rp)
    else if(is.raw(x)) rp <- as.raw(rp)
    else {
      stop(simpleError(
        "unsupported atomic type", call = abortcall
      ))
    }
  }
  return(rp)
}


#' @keywords internal
#' @noRd
.internal_specialattrib <- function() {
  out <- c(
    "comment", "dim", "dimnames", "names", "row.names", "col.names", "tsp",
    "serial"
  )
  return(out)
}
