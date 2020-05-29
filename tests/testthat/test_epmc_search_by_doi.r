context("testing epmc_search_by_doi")

test_that("epmc_search_by_doi returns", {
  a <- epmc_search_by_doi(doi = "10.1161/strokeaha.117.018077")
  my_dois <- c(
    "10.1159/000479962",
    "10.1002/sctm.17-0081",
    "10.1161/strokeaha.117.018077",
    "10.1007/s12017-017-8447-9"
  )
  b <- epmc_search_by_doi(doi = my_dois)
  c <- epmc_search_by_doi(doi = "10.1161/strokeaha.117.018077", output = "raw")
  d <- epmc_search_by_doi(doi = my_dois, output = "id_list")

  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")
  expect_is(c, "list")
  expect_is(d, "tbl_df")

  expect_error(epmc_search_by_doi(doi = my_dois, output = "kd"))
  expect_error(epmc_search_by_doi(doi = my_dois, verbose = "no"))
 })
