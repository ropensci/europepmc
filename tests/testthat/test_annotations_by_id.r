context("testing annotations by id")

test_that("annotations_by_id returns", {
  skip_on_cran()
  a <- annotations_by_id("MED:28585529")
  b <- annotations_by_id(c("MED:28585529", "PMC:PMC1664601"))
  c <- annotations_by_id(c("MED:28585533", "MED:2858553366"))

  # correct dimensions and class
  expect_output(str(a), "tbl_df")
  expect_output(str(b), "tbl_df")
  expect_output(str(c), "tbl_df")

  expect_equal(length(unique(b$ext_id)), 2)
  expect_equal(length(unique(c$ext_id)), 1)

  # fails as expected
  expect_error(annotations_by_id("dd"))
})
