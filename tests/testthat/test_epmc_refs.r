context("testing epmc_refs")

test_that("epmc_refs returns", {
  skip_on_cran()
  a <- epmc_refs("PMC3166943", data_src = "pmc")
  b <- epmc_refs("25378340")
  c <- epmc_refs("2439888", limit = 10)

  #correct dimensions and class
  expect_output(str(a), "data.frame")
  expect_output(str(b), "data.frame")
  expect_output(str(c), "data.frame")

  expect_is(attr(a, "hit_count"), "integer")
  expect_is(attr(b, "hit_count"), "integer")
  expect_is(attr(c, "hit_count"), "integer")

  expect_equal(nrow(c), 10)

  # fails correctly
  expect_error(epmc_refs("14756321"), "No references found")
  expect_error(epmc_refs("13814508", data_src = "abc"))
  expect_error(epmc_refs("2439888", limit = TRUE))
})
