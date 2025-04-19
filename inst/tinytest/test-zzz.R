
x <- letters
expect_true(
  mutatomic:::.rcpp_address(x) %in% mutatomic:::.protected_addresses()
)

x <- 1
expect_false(
  mutatomic:::.rcpp_address(x) %in% mutatomic:::.protected_addresses()
)
