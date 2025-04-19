
#' @keywords Internal
#' @noRd
.C_is_altrep <- function(x) {
  .Call("C_is_altrep", x = x)
}


#' @keywords Internal
#' @noRd
.C_any_badindx <- function(x, val) {
  .Call("C_any_badindx", x = x, val = val)
}

#' @keywords Internal
#' @noRd
.C_any_badmargin <- function(x, val) {
  .Call("C_any_badmargin", x = x, val = val)
}


#' @keywords Internal
#' @noRd
.C_any_nonpos <- function(x) {
  .Call("C_any_nonpos", x = x)
}

#' @keywords Internal
#' @noRd
.C_any_neg <- function(x) {
  .Call("C_any_neg", x = x)
}


#' @keywords Internal
#' @noRd
.C_any_nonNULL <- function(x) {
  .Call("C_any_nonNULL", x = x)
}

#' @keywords Internal
#' @noRd
.C_serial <- function(x) {
  .Call("C_serial", x = x)
}

#' @keywords Internal
#' @noRd
.C_anyaddress <- function(x, v) {
  .Call("C_anyaddress", x = x, v = v)
}

