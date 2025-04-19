
if ( requireNamespace("tinytest", quietly = TRUE) ){
  
  tinytest::test_package(
    "mutatomic", set_env=list(LC_COLLATE="C")
  )
  
  
}


