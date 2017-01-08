context("testing epmc_profile")

test_that("epmc_profile returns", {
  skip_on_cran()
 a <- epmc_profile('malaria')
 b <- epmc_profile('(METHODS:"ropensci")')

 #correct class metadata
 expect_is(a, "list")
 expect_is(b, "list")

 expect_is(a$source, "tbl_df")
 expect_is(a$pubType, "tbl_df")
 expect_is(a$subset, "tbl_df")

 expect_is(b$source, "tbl_df")
 expect_is(b$pubType, "tbl_df")
 expect_is(b$subset, "tbl_df")
})
