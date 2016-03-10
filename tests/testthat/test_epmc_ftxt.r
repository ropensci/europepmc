context("testing epmc_ftxt")

test_that("epmc_ftxt returns", {
  skip_on_cran()
  a <- epmc_ftxt("PMC3257301")
  b <- epmc_ftxt("PMC3639880")

  #correct class metadata
  expect_is(a, "xml_document")
  expect_is(b, "xml_document")

  # fails correctly
  expect_error(epmc_ftxt("23448176", data_src = "med"),
               "Full texts can only be provided for publications indexed in 'pmc'")
})
