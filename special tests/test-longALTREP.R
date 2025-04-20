
# set-up ====

enumerate <- 0 # to count number of tests in loops
errorfun <- function(tt) {
  if(isTRUE(tt)) print(tt)
  if(isFALSE(tt)) stop(print(tt))
}

n <- 2L^31L + 1L

x <- 1:n
expect_true(
  mutatomic:::.C_is_altrep(x)
)
expect_false(
  is.mutatomic(x)
)

x <- as.mutatomic(x)
expect_false(
  mutatomic:::.C_is_altrep(x)
)
expect_true(
  is.mutatomic(x)
)
