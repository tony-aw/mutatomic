
#' @keywords internal
#' @noRd
.mybadge_coercion <- function(x) {
  if(x == "YES") x2 <- "YES-darkgreen"
  if(x == "NO") x2 <- "NO-red"
  if(x == "depends") x2 <- "depends-lightblue"
  txt <- paste0("coercion_through_copy: ", x)
  file <- paste0("coercion_through_copy-", x2, ".svg")
  text <- sprintf("\\link[=mutatomic_coercion]{%s}", txt)
  html <- sprintf(
    "\\figure{%s}{options: alt='[%s]'}",
    file, txt)
  sprintf("\\ifelse{html}{%s}{%s}", html, text)
}

#' @keywords internal
#' @noRd
.mybadge_coercion_by_ref <- function(x) {
  if(x == "YES") x2 <- "YES-darkgreen"
  if(x == "NO") x2 <- "NO-red"
  if(x == "depends") x2 <- "depends-lightblue"
  txt <- paste0("coercion_by_reference: ", x)
  file <- paste0("coercion_by_reference-", x2, ".svg")
  text <- sprintf("\\link[=mutatomic_coercion]{%s}", txt)
  html <- sprintf(
    "\\figure{%s}{options: alt='[%s]'}",
    file, txt)
  sprintf("\\ifelse{html}{%s}{%s}", html, text)
}


#' @keywords internal
#' @noRd
.mybadge_coercion_through_copy <- function(x) {
  if(x == "YES") x2 <- "YES-darkgreen"
  if(x == "NO") x2 <- "NO-red"
  if(x == "depends") x2 <- "depends-lightblue"
  txt <- paste0("coercion_through_copy: ", x)
  file <- paste0("coercion_through_copy-", x2, ".svg")
  text <- sprintf("\\link[=mutatomic_coercion]{%s}", txt)
  html <- sprintf(
    "\\figure{%s}{options: alt='[%s]'}",
    file, txt)
  sprintf("\\ifelse{html}{%s}{%s}", html, text)
}




#' @keywords internal
#' @noRd
.internal_get_protected_addresses_base <- function() {
  env <- baseenv()
  nms <- setdiff(
    ls(env, all.names = TRUE),
    invisible(utils::lsf.str(envir = env, all.names = TRUE))
  )
  protected_binds <- vapply(
    nms,
    \(x) bindingIsLocked(x, env = env) || bindingIsActive(x, env = env),
    logical(1L)
  )
  nms <- setdiff(
    nms[protected_binds],
    c(".Last.value", "Last.value")
  )
  lst <- as.list(env, all.names = TRUE)[nms]
  lst <- rapply(lst, .rcpp_address)
  return(lst)
}

#' @keywords internal
#' @noRd
.internal_get_protected_addresses <- function(env) {
  nms <- setdiff(
    ls(env, all.names = TRUE),
    invisible(utils::lsf.str(envir = env, all.names = TRUE))
  )
  protected_binds <- vapply(
    nms,
    \(x) bindingIsLocked(x, env = env) || bindingIsActive(x, env = env),
    logical(1L)
  )
  nms <- setdiff(
    nms[protected_binds],
    c(".Last.value", "Last.value")
  )
  lst <- as.list(env, all.names = TRUE)[nms]
  subenvs <- vapply(
    lst, is.environment, logical(1L)
  )
  lst[subenvs] <- lapply(lst[subenvs], as.list)
  lst <- rapply(lst, .rcpp_address)
  return(lst)
}

#' @keywords internal
#' @noRd
.protected_addresses <- function() {
  lst1 <- .internal_get_protected_addresses_base()
  lst2 <- .internal_get_protected_addresses(loadNamespace("utils"))
  lst <- c(unlist(lst1), unlist(lst2))
  return(unlist(lst))
}

