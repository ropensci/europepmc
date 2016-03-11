context("testing epmc_details")

test_that("epmc_details returns", {
  skip_on_cran()
  a <- epmc_details(ext_id = "24270414")
  b <- epmc_details(ext_id = "PMC4747116", data_src = "pmc")
  c <- epmc_details("IND43783977", data_src = "agr")
  d <- epmc_details("EP2412369", data_src = "pat")
  e <- epmc_details("583843", data_src = "cba")
  f <- epmc_details("C7603", data_src = "ctx")
  g <- epmc_details("338638", data_src = "hir")
  h <- epmc_details("409323", data_src = "eth")
  i <- epmc_details("NBK338142", data_src = "nbk")

  #correct dimensions and class
  expect_output(str(a), "List of 8")
  expect_output(str(b), "List of 8")
  expect_output(str(c), "List of 8")
  expect_output(str(d), "List of 8")
  expect_output(str(e), "List of 8")
  expect_output(str(f), "List of 8")
  expect_output(str(g), "List of 8")
  expect_output(str(h), "List of 8")
  expect_output(str(i), "List of 8")

  #correct class metadata
  expect_is(a$basic, "data.frame")
  expect_is(b$basic, "data.frame")
  expect_is(c$basic, "data.frame")
  expect_is(d$basic, "data.frame")
  expect_is(e$basic, "data.frame")
  expect_is(a$journal_info, "data.frame")
  expect_is(a$author_details, "data.frame")
  expect_is(a$ftx, "data.frame")
  expect_is(a$chemical, "data.frame")
  expect_is(a$grants, "data.frame")
  expect_is(a$mesh_topic, "data.frame")
  expect_is(a$comments, "data.frame")

  #are diminsions correct?
  expect_equal(nrow(a$basic), 1)
  expect_equal(ncol(a$mesh_topic), 2)

  # fails correctly
  expect_error(epmc_details("123hah"), "nothing found, please check your query")
  expect_error(epmc_details("NBK338142", data_src = "nbks"))
  expect_error(epmc_details("13814508", data_src = "abc"))
})
