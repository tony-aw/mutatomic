
.pkgenv_mutatomic <- new.env(parent=emptyenv())

.onLoad <- function(libname, pkgname) {
  .pkgenv_mutatomic[["protected"]] <- .protected_addresses()
}
