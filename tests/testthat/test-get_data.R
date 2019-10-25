test_that("test valid directory path", {
  expect_error(download_who("wrong_file_path", data = "mort"))
})

path <- file.path("~", "who_mort")
test_that("nrow for mortality table part 1 and 2 combined", {
  expect_equal(nrow(import_who(path, "mort")), 3767064)
})

test_that("nrow for population table", {
  expect_equal(nrow(import_who(path, "pop")), 9435)
})

test_that("nrow for country code table", {
  expect_equal(nrow(import_who(path, "ccode")), 227)
})

test_that("nrow for notes table", {
  expect_equal(nrow(import_who(path, "notes")), 89)
})

test_that("dimensions of data dictionary for mortality", {
  data(dd_mort)
  expect_equal(nrow(dd_mort), 39)
})

test_that("dimensions of data dictionary for population", {
  data(dd_pop)
  expect_equal(nrow(dd_pop), 33)
})

