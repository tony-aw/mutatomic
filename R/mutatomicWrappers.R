
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
.C_serial <- function(x) {
  .Call("C_serial", x = x)
}

#' @keywords Internal
#' @noRd
.C_any_address <- function(x, v) {
  .Call("C_any_address", x = x, v = v)
}

#' @keywords Internal
#' @noRd
.C_copy <- function(x) {
  .Call("C_copy", x = x)
}