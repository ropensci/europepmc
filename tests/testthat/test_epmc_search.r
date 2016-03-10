context("testing epmc_search")

test_that("epmc_search returns", {
  skip_on_cran()
  a <- epmc_search(query='Gabi-Kat')
  b <- epmc_search(query = 'DOI:10.1007/bf00197367')
  c <- epmc_search(query = 'EXT_ID:22246381')
  d <- epmc_search(query = 'ISSN:1553-7404 HAS_EMBL:y')
  e <- epmc_search(query = 'ISSN:1553-7404', id_list= TRUE, n_pages = 2)

  #correct class
  expect_output(str(a), "List of 2")
  expect_output(str(b), "List of 2")
  expect_output(str(c), "List of 2")
  expect_output(str(d), "List of 2")
  expect_output(str(e), "List of 2")

  #correct class metadata
  expect_is(a$data, "data.frame")
  expect_is(b$data, "data.frame")
  expect_is(c$data, "data.frame")
  expect_is(d$data, "data.frame")
  expect_is(e$data, "data.frame")

  #are diminsions correct?
  expect_equal(nrow(e$data), 50)
  expect_equal(ncol(e$data), 4)

  # fails correctly
  expect_error(epmc_search("123haha"), "nothing found, please check your query")
})
