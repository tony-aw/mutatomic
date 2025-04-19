

x <- as.mutatomic(1:10)
y <- x
lockBinding("y", environment())
currentBindings(x)
currentBindings(x, "checklock") # only y is locked


# since only y is locked, we can still modify y through x by reference:
ma_set(x, i = 1, rp = -1)
print(y) # modified!
rm(list= c("y")) # clean up


# one can fix this by locking ALL bindings:
y <- x
currentBindings(x, "lock") # lock all
currentBindings(x, "checklock") # all bindings are locked, including y
# the 'mutatomic' package respects the lock of a binding,
# provided all bindings of an address are locked;
# so this will give an error, as it should:

if(requireNamespace("tinytest")) {
  tinytest::expect_error(
    ma_set(x, i = 1, rp = -1),
    pattern = "cannot change value of locked binding for"
  )
}

# creating a new variable will NOT automatically be locked:
z <- y # new variable; will not be locked!
currentBindings(x, "checklock") # z is not locked
currentBindings(x, "lock") # we must re-run this
currentBindings(x, "checklock") # now z is also locked

if(requireNamespace("tinytest")) {
  tinytest::expect_error( # now z is also protected
    ma_set(z, i = 1, rp = -1),
    pattern = "cannot change value of locked binding for"
  )
}


rm(list= c("x", "y", "z")) # clean up


