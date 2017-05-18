context("testing epmc_lablinks_count")

test_that("epmc_lablinks_count returns", {
  skip_on_cran()
  a <- epmc_lablinks_count("24023770")
  b <- epmc_lablinks_count("PMC3986813", data_src = "pmc")

  #correct dimensions and class
  expect_output(str(a), "data.frame")
  expect_output(str(b), "data.frame")

  # fails correctly
  expect_message(epmc_lablinks_count("239393"),
               "Sorry, no links available")
  expect_null(epmc_lablinks_count("239393"))
  expect_error(epmc_lablinks_count("13814508", data_src = "abc"))
})
