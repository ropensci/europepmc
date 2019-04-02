context("testing epmc_tm")

test_that("epmc_tm returns", {
  skip_on_cran()
  a <- epmc_tm("25249410", semantic_type = "GO_TERM")
  b <- epmc_tm("PMC5467160", data_src = "pmc")
  c <- epmc_tm("PMC4340542", data_src = "pmc", semantic_type = "ORGANISM")
  e <- epmc_tm("25249410")

  #correct dimensions and class
  expect_is(a, "list")
  expect_is(b, "list")
  expect_is(c, "list")
  expect_is(e, "list")

  expect_is(attr(a, "hit_count"), "integer")
  expect_is(attr(b, "hit_count"), "integer")
  expect_is(attr(c, "hit_count"), "integer")
  expect_is(attr(e, "hit_count"), "integer")


  # fails correctly
  expect_message(epmc_tm("14756321", semantic_type = "GO_TERM"),
               "Sorry, no text-mined terms found")
  expect_null(epmc_tm("14756321", semantic_type = "GO_TERM"))
  expect_error(epmc_tm("13814508", data_src = "abc"))
  expect_error(epmc_tm("25249410", semantic_type = "GO_TERMs"))
})
