context("testing epmc_search")

test_that("epmc_search returns", {
  skip_on_cran()
  a <- epmc_search(query='Gabi-Kat')
  b <- epmc_search(query = 'DOI:10.1007/bf00197367')
  c <- epmc_search(query = 'EXT_ID:22246381')
  d <- epmc_search(query = 'ISSN:1553-7404 HAS_EMBL:y')
  e <- epmc_search(query = 'ISSN:1553-7404', id_list= TRUE, limit = 250)
  f <- epmc_search(query = 'ISSN:1553-7404 HAS_EMBL:y', limit = 25)
  g <- epmc_search(query = 'aspirin', synonym = TRUE)


  #correct class metadata
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "data.frame")
  expect_is(d, "data.frame")
  expect_is(e, "data.frame")
  expect_is(g, "data.frame")

  #are diminsions correct?
  expect_equal(nrow(e), 250)
  expect_equal(ncol(e), 4)
  expect_equal(nrow(f), 25)


  # fails correctly
  expect_error(epmc_search("123haha"), "nothing found, please check your query")
  expect_error(epmc_search(query = "malaria", limit = TRUE))
  expect_error(epmc_search(query = "malaria", verbose = "kdk"))
  expect_error(epmc_search(query = "malaria", synonym = "yes"))
})
