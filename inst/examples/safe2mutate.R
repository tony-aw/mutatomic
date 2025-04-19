
x <- 1:16

testfun <- function(x) {
  stopifnot_ma_safe2mutate(substitute(x), parent.frame(n = 1), sys.call())
}

if(requireNamespace("tinytest")) {
  tinytest::expect_error(
    testfun(x),
    pattern = "not a 'mutatomic' object"
  )
}

mylist <- list(
  a = mutatomic(1:10)
)

if(requireNamespace("tinytest")) {
  tinytest::expect_error(
    testfun(mylist$a),
    pattern = "only objects that exist as variables can be modified by reference"
  )
}

lockBinding("x", environment())

if(requireNamespace("tinytest")) {
  tinytest::expect_error(
    testfun(x),
    pattern = "cannot change value of locked binding for"
  )
}


rm(list = "x")

