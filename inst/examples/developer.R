

testfun1 <- function(x) {
  .internal_set_ma(x)
}
testfun2 <- function(x, names = NULL, dim = NULL, dimnames = NULL) {
  .internal_ma_set_DimsAndNames(x, names = names, dim = dim, dimnames = dimnames)
}

x <- 1:10
is.mutatomic(x)

testfun1(x)
is.mutatomic(x)
print(x)

testfun2(
  x,
  letters[1:10],
  c(2, 5),
  list(month.abb[1:2], month.name[1:5])
)

print(x)
