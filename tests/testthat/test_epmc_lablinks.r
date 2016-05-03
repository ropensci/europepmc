context("testing epmc_lablinks")

test_that("epmc_lablinks returns", {
  skip_on_cran()
  a <- epmc_lablinks("24023770", lab_id = "1342")
  b <- epmc_lablinks("24007304", lab_id = "1507")
  c <- epmc_lablinks("12736239", lab_id = "1056")

  #correct dimensions and class
  expect_output(str(a), "data.frame")
  expect_output(str(b), "data.frame")
  expect_output(str(c), "data.frame")

  expect_is(attr(a, "hit_count"), "integer")
  expect_is(attr(b, "hit_count"), "integer")
  expect_is(attr(c, "hit_count"), "integer")

  # fails correctly
  expect_error(epmc_lablinks("13814508", lab_id = "1342"),
               "Sorry, no links available")
  expect_error(epmc_lablinks("13814508"),
               "Please restrict your query to one external link provider. You'll find
         all providers in Europe PMC's advanced search form.")
  expect_error(epmc_lablinks("13814508", n_pages = "abc"))
  expect_error(epmc_lablinks("13814508", data_src = "abc"))
})
