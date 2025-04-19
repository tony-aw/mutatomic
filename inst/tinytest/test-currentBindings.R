
# set-up ====
enumerate <- 0

a <- as.mutatomic(1:10)
refs <- paste0("ref_", letters)
for(i in refs) {
  assign(i, a, envir = environment())
}
`1234567890!@#$%^&*()` <- a

mynms <- expand.grid("random_", letters, letters) |> as.matrix()
mynms <- apply(mynms, 1, \(x)paste(x, collapse = ""))
length(mynms)
for(i in mynms) {
  assign(i, rpois(1, 10), envir = environment())
}


# ma_set gives error when modifying locked objects ====
currentBindings(a)
currentBindings(a, action = "lock")
expect_true(all(currentBindings(a, action = "checklock")))


expect_error(
  ma_set(a, i = 1, rp = -1),
  pattern = "cannot change value of locked binding for"
)
mymat <- as.mutatomic(matrix(1:10, ncol = 2))
lockBinding("mymat", env = environment())
expect_error(
  ma_set(mymat, i = 1, rp = -1)
)
myarr <- as.mutatomic(array(1:27, dim = c(3,3,3)))
lockBinding("myarr", env = environment())
expect_error(
  ma_set(myarr, i = 1, rp = -1),
  pattern = "cannot change value of locked binding for"
)


# clean-up ====
rm(list = c(refs, mynms, "1234567890!@#$%^&*()", "i", "a", "refs", "mynms"),
   envir = environment())

