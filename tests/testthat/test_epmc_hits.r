context("testing epmc_hits")

test_that("epmc_hits returns", {
  skip_on_cran()
  a <- epmc_hits(query='Gabi-Kat')
  b <- epmc_hits(query = 'DOI:10.1007/bf00197367')
  c <- epmc_hits(query = 'EXT_ID:22246381')
  d <- epmc_hits(query = 'ISSN:1553-7404 HAS_EMBL:y')
  e <- epmc_hits(query = 'abstract:"burkholderia pseudomallei"')
  f <- epmc_hits(query = 'aspirin', synonym = TRUE)

  #correct class metadata
  expect_is(a, "integer")
  expect_is(b, "integer")
  expect_is(c, "integer")
  expect_is(d, "integer")
  expect_is(e, "integer")
  expect_is(f, "integer")


  #are diminsions correct?
  expect_equal(length(a), 1)
  expect_equal(length(b), 1)
  expect_equal(length(c), 1)
  expect_equal(length(d), 1)
  expect_equal(length(e), 1)
  expect_equal(length(f), 1)

})
