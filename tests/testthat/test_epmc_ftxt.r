context("testing epmc_ftxt")

test_that("epmc_ftxt returns", {
  skip_on_cran()
  a <- epmc_ftxt("PMC3257301")
  b <- epmc_ftxt("PMC3639880")

  #correct class metadata
  expect_is(a, "xml_document")
  expect_is(b, "xml_document")

  # fails correctly
  expect_error(epmc_ftxt("2PMC3448176"))
  expect_error(epmc_ftxt("PMC3476"))
  expect_error(epmc_ftxt("3476"),
    "Please provide a PMCID, i.e. ids starting with 'PMC'"
    )
})
