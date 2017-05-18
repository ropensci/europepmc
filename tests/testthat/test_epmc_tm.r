context("testing epmc_tm")

test_that("epmc_tm returns", {
  skip_on_cran()
  a <- epmc_tm("25249410", semantic_type = "GO_TERM")
  b <- epmc_tm("PMC4340542", data_src = "pmc", semantic_type = "EFO")
  c <- epmc_tm("PMC4340542", data_src = "pmc", semantic_type = "ORGANISM")

  #correct dimensions and class
  expect_output(str(a), "data.frame")
  expect_output(str(b), "data.frame")
  expect_output(str(c), "data.frame")

  expect_is(attr(a, "hit_count"), "integer")
  expect_is(attr(b, "hit_count"), "integer")
  expect_is(attr(c, "hit_count"), "integer")

  # fails correctly
  expect_message(epmc_tm("14756321", semantic_type = "GO_TERM"),
               "Sorry, no text-mined terms found")
  expect_null(epmc_tm("14756321", semantic_type = "GO_TERM"))
  expect_error(epmc_tm("13814508", data_src = "abc"))
  expect_error(epmc_tm("25249410", semantic_type = "GO_TERMs"))
})
