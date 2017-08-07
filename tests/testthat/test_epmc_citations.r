context("testing epmc_citations")

test_that("epmc_citations returns", {
  skip_on_cran()
  a <- epmc_citations("PMC3166943", data_src = "pmc")
  b <- epmc_citations("9338777")
  c <- epmc_citations("PMC3166943", data_src = "pmc")
  d <- epmc_citations("7535888", limit = 25)
  e <- epmc_citations("20895125")

  #correct dimensions and class
  expect_output(str(a), "data.frame")
  expect_output(str(b), "data.frame")
  expect_output(str(c), "data.frame")
  expect_output(str(d), "data.frame")
  expect_null(e)

  expect_is(attr(a, "hit_count"), "integer")
  expect_is(attr(b, "hit_count"), "integer")
  expect_is(attr(c, "hit_count"), "integer")
  expect_is(attr(d, "hit_count"), "integer")

  #input validation
  expect_error(epmc_citations("13814508", data_src = "abc"))
  expect_error(epmc_citations("7535888", limit = "dj"))
  expect_error(epmc_citations("7535888", verbose = 2))
})
