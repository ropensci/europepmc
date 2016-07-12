context("testing epmc_db")

test_that("epmc_db returns", {
  skip_on_cran()
  a <- epmc_db("12368864", db = "uniprot", limit = 50)
  b <- epmc_db("25249410", db = "embl")
  c <- epmc_db("14756321", db = "uniprot")

  #correct dimensions and class
  expect_output(str(a), "data.frame")
  expect_output(str(b), "data.frame")
  expect_output(str(c), "data.frame")

  expect_is(attr(a, "hit_count"), "integer")
  expect_is(attr(b, "hit_count"), "integer")
  expect_is(attr(c, "hit_count"), "integer")

  expect_equal(nrow(a), 50)

  # fails correctly
  expect_error(epmc_db("14756321"), "Please restrict reponse to a database")
  expect_error(epmc_db("14756321", db = "intact"), "Sorry, no links found")
  expect_error(epmc_db("13814508", data_src = "abc"))
  expect_error(epmc_db("14756321", db = "uniprotl"))
  expect_error(epmc_db("12368864", db = "uniprot", limit = "no"))
})
