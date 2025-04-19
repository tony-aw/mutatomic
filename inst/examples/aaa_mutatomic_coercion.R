
# Coercion examples - mutatomic ====

x <- as.mutatomic(1:16)
ma_set(x, i = 1:6, rp = 8.5) # 8.5 coerced to 8, because `x` is of type `integer`
print(x)

#############################################################################

# Coercion examples - data.table - whole columns ====

obj <- data.table::data.table(
  a = 1:10, b = letters[1:10], c = 11:20, d = factor(letters[1:10])
)
str(obj) # notice that columns "a" and "c" are INTEGER (`int`)

data.table::set(
  obj, j = c("a", "c"),
  value = -1 # SAFE: row=NULL & obs = NULL, so coercion performed
)
str(obj)

#############################################################################


# Coercion examples - data.table - partial columns ====

obj <- data.table::data.table(
  a = 1:10, b = letters[1:10], c = 11:20, d = factor(letters[1:10])
)
str(obj) # notice that columns "a" and "c" are INTEGER (`int`)
data.table::set(
  obj, i = which(with(obj, (a >= 2) & (c <= 17))), j = c("a", "c"),
  value = -1
  # WARNING: sqrt() results in `dbl`, but columns are `int`, so decimals lost
)
print(obj)



#############################################################################

# View of List ====

x <- list(
  a = mutatomic(letters[1:10]),
  b = mutatomic(letters[11:20])
)
myref <- x$a
ma_set(myref, 1L, "xxx")
print(x)
myref <- x$a
address(myref) == address(x$a) # they are the same
print(x) # notice x has been changed


