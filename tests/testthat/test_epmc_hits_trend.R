context("testing epmc_hits_trend")

test_that("epmc_hits_trend returns", {
  skip_on_cran()
  a <- epmc_hits_trend('aspirin', period = 2006:2016, synonym = FALSE)
  b <- epmc_hits_trend('REF:"cran.r-project.org*"', period = 2006:2016, synonym = FALSE)
  c <- epmc_hits_trend('(REF:"cran.r-project.org*") AND (SRC:"MED") AND (PUB_TYPE:"Review" OR PUB_TYPE:"review-article")', period = 2006:2016, synonym = FALSE)

  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")
  expect_is(c, "tbl_df")

  expect_true(all(names(a) == c("year", "all_hits", "query_hits")))
  expect_true(all(names(b) == c("year", "all_hits", "query_hits")))
  expect_true(all(names(c) == c("year", "all_hits", "query_hits")))

  expect_true(all(a$year == 2006:2016))
  expect_true(all(b$year == 2006:2016))
  expect_true(all(c$year == 2006:2016))
})

test_that("epmc_hits_trend fails correctly", {
  skip_on_cran()
  # input validation
  expect_error(epmc_hits_trend("aspirin", period = "2006:2004", synonym = FALSE))
  expect_error(epmc_hits_trend("aspirin", period = 2006:2008, synonym = "f"))
  expect_error(epmc_hits_trend(query = 123, period = 2006:2008))
})
