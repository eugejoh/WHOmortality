test_that("test valid directory path", {
  expect_error(download_who(dest = "wrong_file_path", data = "mort"))
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

test_that("dimensions of data dictionary for ICD-10 codes", {
  data(dd_icd10)
  expect_equal(nrow(dd_icd10), 104)
})

test_that("snake case function named", {
  data(dd_icd10)
  names(dd_icd10) <- NULL
  expect_error(snakecase_cols(dd_icd10), regexp = "is.null")
})

test_that("snake case function input class", {
  x <- c("a", "b", "c")
  expect_error(proc_who_mort(x))
})
