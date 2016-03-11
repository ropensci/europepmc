context("testing epmc_tm")

test_that("epmc_tm returns", {
  skip_on_cran()
  a <- epmc_tm("25249410", semantic_type = "GO_TERM")
  b <- epmc_tm("PMC4340542", data_src = "pmc", semantic_type = "EFO")
  c <- epmc_tm("PMC4340542", data_src = "pmc", semantic_type = "ORGANISM")

  #correct dimensions and class
  expect_output(str(a), "List of 2")
  expect_output(str(b), "List of 2")
  expect_output(str(c), "List of 2")

  #correct class metadata
  expect_is(a$data, "data.frame")
  expect_is(b$data, "data.frame")
  expect_is(c$data, "data.frame")
  expect_is(a$hit_count, "integer")

  # fails correctly
  expect_error(epmc_tm("14756321", semantic_type = "GO_TERM"),
               "Sorry, no text-mined terms found")
  expect_error(epmc_tm("13814508", n_pages = "abc"))
  expect_error(epmc_tm("13814508", data_src = "abc"))
  expect_error(epmc_tm("25249410", semantic_type = "GO_TERMs"))
})
