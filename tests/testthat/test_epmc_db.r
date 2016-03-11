context("testing epmc_db")

test_that("epmc_db returns", {
  skip_on_cran()
  a <- epmc_db("12368864", db = "uniprot", n_pages = 2)
  b <- epmc_db("25249410", db = "embl")
  c <- epmc_db("14756321", db = "uniprot")

  #correct dimensions and class
  expect_output(str(a), "List of 3")
  expect_output(str(b), "List of 3")
  expect_output(str(c), "List of 3")

  #correct class metadata
  expect_is(a$data, "data.frame")
  expect_is(b$data, "data.frame")
  expect_is(c$data, "data.frame")
  expect_is(a$hit_count, "integer")

  expect_equal(nrow(a$data), 50)

  # fails correctly
  expect_error(epmc_db("14756321"), "Please restrict reponse to a database")
  expect_error(epmc_db("14756321", db = "intact"), "No references available")
  expect_error(epmc_db("13814508", n_pages = "abc"))
  expect_error(epmc_db("13814508", data_src = "abc"))
  expect_error(epmc_db("14756321", db = "uniprotl"))
})
