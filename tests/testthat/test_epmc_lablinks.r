context("testing epmc_lablinks")

test_that("epmc_lablinks returns", {
  skip_on_cran()
  a <- epmc_lablinks("26345659", lab_id = "1056")
  b <- epmc_lablinks("24007304", lab_id = "1507")
  c <- epmc_lablinks("12736239", lab_id = "1056")
  d <- epmc_lablinks("24007304", lab_id = c("1507", "1562"))
  e <- epmc_lablinks("PMC5074493", data_src = "pmc")

  #correct dimensions and class
  expect_output(str(a), "data.frame")
  expect_output(str(b), "data.frame")
  expect_output(str(c), "data.frame")
  expect_output(str(d), "data.frame")
  expect_output(str(e), "data.frame")



  expect_is(attr(a, "hit_count"), "integer")
  expect_is(attr(b, "hit_count"), "integer")
  expect_is(attr(c, "hit_count"), "integer")
  expect_is(attr(d, "hit_count"), "integer")
  expect_is(attr(e, "hit_count"), "integer")



  # fails correctly
  expect_message(epmc_lablinks("13814508", lab_id = "1342"),
               "Sorry, no links available")
  expect_null(epmc_lablinks("13814508", lab_id = "1342"))
  expect_null(epmc_lablinks("13814508"))
  expect_error(epmc_lablinks("13814508", data_src = "abc"))
})
