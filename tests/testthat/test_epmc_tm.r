context("testing epmc_tm")

test_that("epmc_tm returns", {
  skip_on_cran()
  expect_error(epmc_tm("25249410", semantic_type = "GO_TERM"))
})
