context("testing epmc_citations")

test_that("epmc_citations returns", {
  skip_on_cran()
  a <- epmc_citations("PMC3166943", data_src = "pmc")
  b <- epmc_citations("9338777")
  c <- epmc_citations("PMC3166943", data_src = "pmc")
  d <- epmc_citations("7535888", n_pages = 1)

  #correct dimensions and class
  expect_output(str(a), "List of 2")
  expect_output(str(b), "List of 2")
  expect_output(str(c), "List of 2")
  expect_output(str(d), "List of 2")

  #correct class metadata
  expect_is(a$data, "data.frame")
  expect_is(b$data, "data.frame")
  expect_is(c$data, "data.frame")
  expect_is(d$data, "data.frame")
  expect_is(a$hit_count, "integer")

  # fails correctly
  expect_error(epmc_citations("13814508"), "This article has not been cited yet")
  expect_error(epmc_citations("13814508", n_pages = "abc"))
  expect_error(epmc_citations("13814508", data_src = "abc"))
})
