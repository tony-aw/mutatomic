#' Check If an Atomic Object is Safe to Mutate
#'
#' @description
#' Arguably the most important function of 'mutatomic' for package development
#' is the `stopifnot_ma_safe2mutate()` function,
#' which checks if an atomic object is actually safe to mutate. \cr
#' Package authors who wish to use 'mutatomic' for pass-by-reference semantics
#' ought to check if an atomic object is safe to mutate using the `stopifnot_ma_safe2mutate()` function; \cr
#' otherwise things might break in 'R'. \cr
#' 
#'  
#' @param sym the symbol of the object; i.e. `substitute(x)`.
#' @param envir the environment where the object resides; i.e. `parent.frame(n = 1)`.
#' @param .abortcall environment where the error message is passed to.
#' 
#' 
#' @returns
#' Nothing. Only gives an error if the object is not safe to mutate.
#' 
#' 
#' @example inst/examples/safe2mutate.R
#' 
#' 

#' @rdname safe2mutate
#' @export
stopifnot_ma_safe2mutate <- function(sym, envir, .abortcall) {
  
  if(!is.symbol(sym) || length(sym) > 1L) {
    stop(simpleError(
      "only objects that exist as variables can be modified by reference", call = .abortcall
    ))
  }
  if(bindingIsLocked(sym, env = envir)){
    txt <- paste0("cannot change value of locked binding for '", sym, "'")
    stop(simpleError(txt, call = .abortcall))
  }
  x <- get(sym, envir = envir)
  if(!is.atomic(x)) {
    txt <- paste0("'", sym, "' is not atomic")
    stop(simpleError(txt, call = .abortcall))
  }
  if(!is.mutatomic(x)) {
    txt <- paste0("'", sym, "' is not a 'mutatomic' object")
    stop(simpleError(txt, call = .abortcall))
  }
  
}
