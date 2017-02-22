context("testing epmc_db_count")

test_that("epmc_db_count returns", {
  skip_on_cran()
  a <- epmc_db_count("25249410")
  b <- epmc_db_count("14756321")
  c <- epmc_db_count("11805837")

  #correct dimensions and class
  expect_output(str(a), "data.frame")
  expect_output(str(b), "data.frame")
  expect_output(str(c), "data.frame")


  # fails correctly
  expect_error(epmc_db_count("22326070"),
               "Nothing found")
  expect_error(epmc_db_count("13814508", data_src = "abc"))
})
