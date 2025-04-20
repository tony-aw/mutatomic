

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

testfun1 <- function(x) {
  .internal_set_ma(x)
}
testfun2 <- function(x, names = NULL, dim = NULL, dimnames = NULL) {
  .internal_ma_set_DimsAndNames(x, names = names, dim = dim, dimnames = dimnames)
}


nms <- list(NULL, letters[1:10])
dms <- list(NULL, c(2, 5))
dmnms <- list(
  NULL,
  list(month.abb[1:2], NULL),
  list(NULL, month.name[1:5]),
  list(month.abb[1:2], month.name[1:5])
)

for(i in seq_along(x.data)) {
  x <- data.table::copy(x.data[[i]])
  expect_false(
    is.mutatomic(x)
  ) |> errorfun()
  
  testfun1(x)
  invisible(x)
  
  expect_true(
    is.mutatomic(x)
  ) |> errorfun()
}


for(iData in seq_along(x.data)) {
  for(iNms in seq_along(nms)) {
    for(iDims in seq_along(dms)) {
      for(iDimnames in seq_along(dmnms)) {
        
        print(iNms)
        print(iDims)
        print(iDimnames)
        
        x <- data.table::copy(x.data[[iData]][1:10])
        testfun1(x)
        
        if(is.null(dms[[iDims]])) {
          testfun2(x, names = nms[[iNms]], dim = dms[[iDims]])
          invisible(x) # waking up R
        }
        if(!is.null(dms[[iDims]])) {
          testfun2(
            x, names = nms[[iNms]], dim = dms[[iDims]], dimnames = dmnms[[iDimnames]]
          )
          invisible(x) # waking up R
          expect_equal(
            dimnames(x),
            dmnms[[iDimnames]]
          ) |> errorfun()
          enumerate <- enumerate + 1L
        }
        
        invisible(x) # waking up R
        
        expect_equal(
          names(x),
          nms[[iNms]]
        ) |> errorfun()
        expect_equal(
          dim(x),
          dms[[iDims]]
        ) |> errorfun()
        
        enumerate <- enumerate + 2L
      }
    }
  }
  
}

for(i in seq_along(x.data)) {
  x <- data.table::copy(x.data[[i]][1:10])
  testfun1(x)
  
  testfun2(
    x,
    letters[1:10],
    c(2, 5),
    list(month.abb[1:2], month.name[1:5])
  )
  expect_equal(
    names(x),
    letters[1:10]
  ) |> errorfun()
  expect_equal(
    dim(x),
    c(2, 5)
  ) |> errorfun()
  expect_equal(
    dimnames(x),
    list(month.abb[1:2], month.name[1:5])
  ) |> errorfun()
  enumerate <- enumerate + 3L
  
  
}



# errors ====

x <- list(1:10)
expect_error(
  testfun1(x),
  pattern = "not atomic or not convertible"
)
expect_error(
  testfun1(as.factor(1:10)),
  pattern = "not atomic or not convertible"
)
x <- 1:10
expect_error(
  testfun2(x),
  pattern = "not mutatomic"
)
enumerate <- enumerate + 3L

