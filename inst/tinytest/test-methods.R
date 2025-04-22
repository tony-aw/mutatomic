
# set-up ====

enumerate <- 0 # to count number of tests in loops
errorfun <- function(tt) {
  if(isTRUE(tt)) print(tt)
  if(isFALSE(tt)) stop(print(tt))
}

x.data <- list(
  sample(c(TRUE, FALSE, NA), 100, TRUE),
  sample(c(1:98, NA, NA)),
  rnorm(100),
  sample(c(NA, NaN, -Inf, Inf, 0), 100, TRUE),
  sample(c(letters, LETTERS, NA, NA), 100, TRUE),
  as.complex(c(1:99, NA)),
  as.raw(0:99),
  rep(NA, 100)
)


# sub-setting ====
x <- matrix(1:20, ncol = 4)
y <- as.mutatomic(x)
expect_equal(
  as.mutatomic(x[1:2, ,drop = FALSE]),
  y[1:2, , drop = FALSE]
 
)
expect_equal(
  as.mutatomic(x[,1:2 ,drop = FALSE]),
  y[,1:2 , drop = FALSE]
  
)
expect_equal(
  as.mutatomic(x[2:3]),
  y[2:3]
)

enumerate <- enumerate + 3L



#  replacement ====
x <- matrix(1:20, ncol = 4)
y <- as.mutatomic(x)
x[1] <- -1
y[1] <- -1
expect_equal(
  as.mutatomic(x),
  y
)
enumerate <- enumerate + 3L



# Concatenation ====
x <- mutatomic(1:10)
y <- mutatomic(11:20)
expect_equal(
  c(x, y),
  mutatomic(1:20)
)
enumerate <- enumerate + 1L


# as.* ====
for(i in seq_along(x.data)) {
  x <- x.data[[i]]
  expect_equal(
    mutatomic(as.logical(x)),
    as.logical(mutatomic(x))
  ) |> errorfun()
  
  expect_equal(
    mutatomic(as.integer(x)),
    as.integer(mutatomic(x))
  ) |> errorfun()
  
  expect_equal(
    mutatomic(as.double(x)),
    as.double(mutatomic(x))
  ) |> errorfun()
  
  expect_equal(
    mutatomic(as.complex(x)),
    as.complex(mutatomic(x))
  ) |> errorfun()
  
  expect_equal(
    mutatomic(as.character(x)),
    as.character(mutatomic(x))
  ) |> errorfun()
  
  expect_equal(
    mutatomic(as.raw(x)),
    as.raw(mutatomic(x))
  ) |> errorfun()
}

enumerate <- enumerate + 6 * length(x.data)

