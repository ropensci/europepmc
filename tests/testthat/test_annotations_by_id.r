context("testing annotations by id")

test_that("epmc_epmc_annotations_by_id returns", {
  skip_on_cran()
  a <- epmc_annotations_by_id("MED:28585529")
  b <- epmc_annotations_by_id(c("MED:28585529", "PMC:PMC1664601"))
  c <- epmc_annotations_by_id(c("MED:28585533", "MED:2858553366"))
  # missing pmcid json element
  d <- epmc_annotations_by_id("MED:10566658")

  # correct dimensions and class
  expect_output(str(a), "tbl_df")
  expect_output(str(b), "tbl_df")
  expect_output(str(c), "tbl_df")
  expect_output(str(d), "tbl_df")


  expect_equal(length(unique(b$ext_id)), 2)
  expect_equal(length(unique(c$ext_id)), 1)
  expect_true(unique(is.na(d$pmcid)))

  # fails as expected
  expect_error(epmc_annotations_by_id("dd"))
})
