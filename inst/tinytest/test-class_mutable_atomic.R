
# set-up ====

enumerate <- 0 # to count number of tests in loops


# is.mutatomic ====
x <- 0:10
expect_false(
  is.mutatomic(as.logical(x))
)
expect_false(
  is.mutatomic(as.integer(x))
)
expect_false(
  is.mutatomic(as.double(x))
)
expect_false(
  is.mutatomic(as.character(x))
)
expect_false(
  is.mutatomic(as.complex(x))
)
expect_false(
  is.mutatomic(as.raw(x))
)

x <- as.mutatomic(x)
expect_true(
  is.mutatomic(x)
)

x <- factor(letters)
class(x) <- "mutatomic"
attr(x, 'typeof') <- typeof(x)
expect_false(
  is.mutatomic(as.character(x))
)

enumerate <- enumerate + 8


# couldb.mutatomic ====
x <- 0:10
expect_true(
  couldb.mutatomic(as.logical(x))
)
expect_true(
  couldb.mutatomic(as.integer(x))
)
expect_true(
  couldb.mutatomic(as.double(x))
)
expect_true(
  couldb.mutatomic(as.character(x))
)
expect_true(
  couldb.mutatomic(as.complex(x))
)
expect_true(
  couldb.mutatomic(as.raw(x))
)

enumerate <- enumerate + 6


# as.mutatomic vs mutatomic - vector ====
x <- 1:10
expect_equal(
  as.mutatomic(x),
  mutatomic(1:10)
)
names(x) <- letters[1:10]
expect_equal(
  as.mutatomic(x),
  mutatomic(1:10, names = letters[1:10])
)
enumerate <- enumerate + 2


# as.mutatomic vs mutatomic - matrix ====
x <- matrix(1:20, ncol = 4)
expect_equal(
  as.mutatomic(x),
  mutatomic(1:20, dim = c(5, 4))
)
dimnames(x) <- list(NULL, letters[1:4])
expect_equal(
  as.mutatomic(x),
  mutatomic(x, dim = c(5, 4), dimnames = list(NULL, letters[1:4]))
)

x <- matrix(1:20, ncol = 4)
names(x) <- letters[1:20]
expect_equal(
  as.mutatomic(x),
  mutatomic(x, dim = c(5, 4), names = letters[1:20])
)
dimnames(x) <- list(NULL, letters[1:4])
expect_equal(
  as.mutatomic(x),
  mutatomic(x, dim = c(5, 4), names = letters[1:20], dimnames = list(NULL, letters[1:4]))
)

enumerate <- enumerate + 4


# as.mutatomic vs mutatomic - array ====
x <- array(1:27, dim = c(3,3,3))
dimnames(x) <- list(NULL, NULL, letters[1:3])
expect_equal(
  as.mutatomic(x),
  mutatomic(1:27, dim = c(3,3,3), dimnames = list(NULL, NULL, letters[1:3]))
)
names(x) <- c(letters, NA)
expect_equal(
  as.mutatomic(x),
  mutatomic(1:27, dim = c(3,3,3), dimnames = list(NULL, NULL, letters[1:3]), names = c(letters, NA))
)

enumerate <- enumerate + 3



# as.mutatomic vs mutatomic vs materialize_atomic - ALTREP ====
x <- 1:1e6
is_altrep <- squarebrackets:::.C_is_altrep
expect_true(is_altrep(x))
expect_false(as.mutatomic(x) |> is_altrep())
expect_false(mutatomic(x) |> is_altrep())
enumerate <- enumerate + 2L


# materialize ====
x <- 1:10
expect_true(
  mutatomic:::.C_is_altrep(x)
)
x <- as.mutatomic(x)
expect_false(
  mutatomic:::.C_is_altrep(x)
)
expect_true(
  is.mutatomic(x)
)

x <- 1:10
expect_true(
  mutatomic:::.C_is_altrep(x)
)
x <- mutatomic(x)
expect_false(
  mutatomic:::.C_is_altrep(x)
)
expect_true(
  is.mutatomic(x)
)
enumerate <- enumerate + 6L


# partial matrix sub-setting ====
x <- as.mutatomic(matrix(1:20, ncol = 4))
expect_true(
  is.mutatomic(x[1, ,drop = FALSE])
)
expect_true(
  is.mutatomic(x[, 1,drop = FALSE])
)

enumerate <- enumerate + 2


# errors ====

expect_error(
  mutatomic(list(1:10)),
  pattern = "non-atomic or non-convertible data given"
)
expect_error(
  mutatomic(as.factor(1:10)),
  pattern = "non-atomic or non-convertible data given"
)
expect_error(
  as.mutatomic(list(1:10)),
  "not atomic or not convertible"
)
expect_error(
  as.mutatomic(factor(letters)),
  "not atomic or not convertible"
)

enumerate <- enumerate + 4

