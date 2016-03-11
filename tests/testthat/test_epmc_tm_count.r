context("testing epmc_tm_count")

test_that("epmc_tm_count returns", {
  skip_on_cran()
  a <- epmc_tm_count("25249410")
  b <- epmc_tm_count("PMC4340542", data_src = "pmc")
  c <- epmc_tm_count("PMC4340542", data_src = "pmc")

  #correct dimensions and class
  expect_output(str(a), "data.frame")
  expect_output(str(b), "data.frame")
  expect_output(str(c), "data.frame")

  # fails correctly
  expect_error(epmc_tm_count("14756321"),
               "Sorry, no text-mined terms found")
  expect_error(epmc_tm_count("13814508", data_src = "abc"))
})
