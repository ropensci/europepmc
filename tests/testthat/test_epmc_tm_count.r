context("testing epmc_tm_count")

test_that("epmc_tm_count returns", {
  skip_on_cran()
  expect_error(epmc_tm_count("25249410"))
})
