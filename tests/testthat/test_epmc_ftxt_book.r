context("testing epmc_ftxt_book")

test_that("epmc_ftxt_book returns", {
  skip_on_cran()
#  a <- epmc_ftxt_book("10510270")
  b <- epmc_ftxt_book("NBK32884")

  #correct class metadata
#  expect_is(a, "xml_document")
  expect_is(b, "xml_document")

})
