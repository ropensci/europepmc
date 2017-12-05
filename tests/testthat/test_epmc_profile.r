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

test_that("epmc_profile synonym parameter works", {
  skip_on_cran()
  a <- epmc_profile("malaria")
  b <- epmc_profile("malaria", synonym = FALSE)
  c <- epmc_profile("jupyter")
  d <- epmc_profile("jupyter", synonym = FALSE)

  expect_gte(sum(a$source$count), sum(b$source$count))
  expect_gte(sum(c$source$count), sum(d$source$count))
})
