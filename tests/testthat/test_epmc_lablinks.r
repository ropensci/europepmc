context("testing epmc_lablinks")

test_that("epmc_lablinks returns", {
  skip_on_cran()
  a <- epmc_lablinks("24023770", lab_id = "1342")
  b <- epmc_lablinks("24007304", lab_id = "1507")
  c <- epmc_lablinks("12736239", lab_id = "1056")

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
  expect_error(epmc_lablinks("13814508", lab_id = "1342"),
               "Sorry, no links available")
  expect_error(epmc_lablinks("13814508"),
               "Please restrict your query to one external link provider. You'll find
         all providers in Europe PMC's advanced search form.")
})
