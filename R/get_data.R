library(here)
library(janitor)
library(tidyverse)
# taken directly from https://www.who.int/healthinfo/statistics/mortality_rawdata/en/

base_url_mort <- "https://www.who.int/healthinfo/statistics/"
base_url_pop <- "https://www.who.int/healthinfo/"

file_url_mort <- c("Morticd10_part1.zip", "Morticd10_part2.zip", "country_codes.zip", "documentation.zip", "availability.zip", "notes.zip")
file_url_pop <- c("pop.zip")

urls_mort <- paste(base_url_mort, file_url_mort, sep = "")
urls_pop <- paste(base_url_pop, file_url_pop, sep = "")

# Destination Directory for .zip files
dir.create("/Users/eugenejoh/who_mort")
dest_path <- "/Users/eugenejoh/who_mort"

# Download .zip files from WHO url
if (length(list.files(dest_path)) == 0) {
  for (i in seq_along(urls_mort)) {
    utils::download.file(url = urls_mort[i], destfile = file.path(dest_path, file_url_mort[i]))
  }
  utils::download.file(url = urls_pop, destfile = file.path(dest_path, file_url_pop))
}

# Extract .zip files in local directory
extract_these <- list.files(dest_path, pattern = "\\.zip$", full.names = TRUE)[!grepl("availability|documentation|notes", list.files(dest_path, pattern = "\\.zip$", full.names = TRUE))]
if (length(list.files(dest_path, pattern = "\\.csv$")) == 0) {
  sapply(extract_these, function(x) unzip(zipfile = x, exdir =  dest_path))
}


if (length(list.files(dest_path, pattern = "\\.csv$")) == 0) {
  oldnames <- list.files(dest_path, full.names = TRUE)[!grepl("\\.zip$", x = list.files(dest_path, full.names = TRUE))]
  newnames <- paste0(oldnames, ".csv")
  # Change names of extracted files to .csv extension
  lapply(seq_along(oldnames), function(i) file.rename(oldnames, newnames))
}

# Import mortality .csv files
who_data <- lapply(
  list.files(dest_path, pattern = "\\.csv", full.names = TRUE),
  readr::read_csv,
  col_types = readr::cols(.default = "c")
) %>%
  setNames(basename(tools::file_path_sans_ext(
    list.files(dest_path, pattern = "\\.csv", full.names = TRUE)
  )))

# combine the mortality data but check variable names first
# see what column names overlap in Deaths data
Reduce(intersect, lapply(who_data[grepl("^Mort",names(who_data))], names))
# see what colums names overlap with all tables
Reduce(setdiff, lapply(who_data[grepl("^Mort",names(who_data))], names))

who_mort_icd10 <- dplyr::bind_rows(who_data[grepl("Morticd10_part[0-9]", names(who_data))])

# get population data
who_pop <- who_data[["pop"]]

# country codes
who_cnt_codes <- who_data[["country_codes"]]

rm(who_data)

# Process WHO data
# specify data types
proc_who_data <- function(y) {
  y <- mutate_at(y, vars(matches("Deaths[0-9]{,2}$|Pop|Lb")), as.numeric)
  y <- mutate_at(y, vars("Sex"), as.factor)
  y <- mutate_at(y, vars("Year"), as.integer)
  y
}
who_mort_icd10 <- proc_who_data(who_mort_icd10)
# clean names
who_mort_icd10 <- janitor::clean_names(who_mort_icd10)

