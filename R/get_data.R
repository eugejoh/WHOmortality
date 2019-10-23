#' Download WHO Mortality Data
#' 
#' This function downloads the raw WHO mortality data based on the links on the webpage \url{https://www.who.int/healthinfo/statistics/mortality_rawdata/en/}
#'
#' @param dest a \code{character} file path of the destintation directory to download the .zip files
#' @param data to specify which files to download, default value downloads the documentation files
#' 
#' @details The \code{data} parameter allows the user to download a specific set of data files.
#' The \code{docs} downloads the documentation files associated with the raw WHO mortality data, this includes the "documentation.zip", "notes.zip", and "availability.zip" files
#' The \code{mort} downloads the two ICD-10 mortality .zip files, "Morticd10_part1.zip" and "Morticd10_part2.zip"
#' The \code{pop} downloads the WHO population data, "pop.zip"
#' The \code{ccode} downloads the country code table "country_codes.zip"
#' The \code{all} downloads all the abovementioned .zip files at once
#' 
#' @return the same value as the \code{\link[utils]{download.file}}
#' @export
#'
#' @examples
#' \dontrun{
#' download_who(dest = getwd(), data = "ccode")
#' }
download_who <- function(dest, data = c("docs", "mort", "pop", "ccode", "all")) {
  stopifnot(dir.exists(dest)) #stop if directory doesn't exist

  if (length(data) > 1) data <- "docs" #if the data arguement is default value (length > 1) then only download documentation
  
  .dl_file <- function(file_url, data) { #helper file
    utils::download.file(url = file_url, destfile = file.path(dest, paste0(data)))
  }
  
  if (data == "pop") { #want to download population data, specify the URL
    base_url <- "https://www.who.int/healthinfo/statistics/"
    data_list <- list(
      pop = c("pop.zip")
    )
  }
  
  if (data != "pop") { #want to download other data, specify the base URL
    base_url <- "https://www.who.int/healthinfo/statistics/"
    # then make a list to map the URL values
    data_list <- list(
      docs = c("documentation.zip", "notes.zip", "availability.zip"),
      mort = c("Morticd10_part1.zip", "Morticd10_part2.zip"),
      ccode = "country_codes.zip"
    )
    # based on `data` parameter, extract respective value from list above and generate final URL
  }
  
  file_url <- paste0(base_url, data_list[[data]])
  data_list[[data]]
  
  if (data != "all") { #download the data based on `file_url`
    for (i in seq_along(file_url)) {
      .dl_file(file_url[i], data_list[[data]][i])
    }
  }
  
  if (data == "all") { #if `data` parameter is "all", then download all the data in `data_list`
    for (j in c("docs", "ccode", "mort")) {
      file_url <- paste0(base_url, data_list[[j]])
      for (i in seq_along(file_url)) {
        .dl_file(file_url[i], data_list[[j]][i])
      }
    }
    .dl_file("https://www.who.int/healthinfo/pop.zip", "pop.zip")
  }
}

#' Extract WHO Mortality Data
#'
#' @param path a \code{character} file path where the downloaded WHO .zip files exist
#' @param dest a \code{character} destination file path to extract, default value will be \code{path}
#'
#' @return a named \code{logical} vector of the files that were successfully extracted
#' @export
#'
#' @examples
#' \dontrun{
#' download_who(dest = getwd(), data = "ccode")
#' download_who(dest = getwd(), data = "docs")
#' extract_who(path = getwd(), dest = getwd(), convert = TRUE)
#' }
extract_who <- function(path, dest) {
  if (missing(dest)) dest <- path
  who_csv_files <- c(
    "notes", 
    "Morticd10_part1", 
    "Morticd10_part2", 
    "country_codes", 
    "pop"
  )
  regex <- paste(who_csv_files, collapse = "|", sep = "|")
  all_zip <- list.files(path, pattern = "\\.zip$", full.names = TRUE)
  extract_these <- all_zip[grepl(regex, all_zip)]
  sapply(extract_these, function(x) utils::unzip(zipfile = x, exdir = dest))
  
    exist_files <- list.files(dest, pattern = paste(paste0(who_csv_files, "$"), collapse = "|"))
    sapply(exist_files, function(x) {
      oldnames <- x
      newnames <- paste0(x, ".csv")
      file.rename(from = oldnames, to = newnames)
    })
}
  
#' Import WHO Mortality Data
#' 
#' This function imports the csv WHO mortality files, extracted from downloaded zip files from a local directory
#'
#' @param path a \code{character} file path where the extracted .csv WHO files exist
#' @param data a \code{character} to specify which files to import into R, must be explicitly defined
#' 
#' @details The \code{data} parameter allows the user to download a specific set of data files.
#' The \code{mort} imports the two ICD-10 mortality csv files, "Morticd10_part1.zip" and "Morticd10_part2.zip" and combines them into a single \code{tibble} object
#' The \code{pop} imports the WHO population csv file
#' The \code{ccode} imports the country code csv file
#' The \code{notes} imports the notes csv file
#'
#' @return a \code{tibble} object of the specified data
#' @export
#'
#' @examples
#' \dontrun{
#' download_who(dest = getwd(), data = "ccode")
#' extract_who(path = getwd(), dest = getwd(), convert = TRUE)
#' ccode_df <- import_who(path = getwd(), data = "ccode")
#' head(ccode_df)
#' }
import_who <- function(path, data = c("mort", "pop", "ccode", "notes")) {
  stopifnot(length(data) == 1)
  who_csv_files <- c(
    "notes", 
    "Morticd10_part1", 
    "Morticd10_part2", 
    "country_codes", 
    "pop"
  )
  regex <- paste(who_csv_files, collapse = "|", sep = "|")
  all_csv <- list.files(path, pattern = "\\.csv$", full.names = TRUE)
  
  if (data == "mort") {
    mort_l <- lapply(all_csv[grepl("Morticd10_part1|Morticd10_part2", all_csv)],
           function(x) {
             readr::read_csv(file = x, col_types = readr::cols(.default = "c"))
           })
    
    vars_intersect <- Reduce(intersect, lapply(mort_l, names))
    vars_setdiff <- Reduce(setdiff, lapply(mort_l, names))
    if (any(length(vars_intersect) != ncol(mort_l[[1]]) | length(vars_setdiff) != 0))
      stop("check that mortality .csv files are correct: column names not consistent")
    
    out <- dplyr::bind_rows(mort_l)
  }

  if (data == "pop") {
    out <- readr::read_csv(file = all_csv[grepl("pop", all_csv)])
  }
  
  if (data == "ccode") {
    out <- readr::read_csv(file = all_csv[grepl("country_codes", all_csv)])
  }
  
  if (data == "notes") {
    out <- readr::read_csv(file = all_csv[grepl("notes", all_csv)])
  }
  
  return(out)
}

#' Process Raw WHO Mortality Data
#' 
#' This function processes the original WHO mortality csv file to correct data types for each column.
#'
#' @param x a \code{data.frame} of the original csv WHO mortality table, this is the output of \code{\link{import_who}}
#'
#' @return a \code{data.frame} object with modified column data types
#' @export

#' @examples
#' \dontrun{
#' mort <- import_who(path = getwd(), data = "mort")
#' mort <- proc_who_mort(mort)
#' }
proc_who_mort <- function(x) {
  stopifnot(is.data.frame(x))
  
  y <- dplyr::mutate_at(x, dplyr::vars(tidyselect::matches("Deaths[0-9]{,2}$|Pop|Lb")), as.numeric)
  y <- dplyr::mutate_at(y, dplyr::vars("Sex"), as.factor)
  out <- dplyr::mutate_at(y, dplyr::vars("Year"), as.integer)
  
  return(out)
}

#' Convert Column Names to Lower Snake Case
#' 
#' This function converts all column names of input \code{data.frame} to lower snake case.
#'
#' @param x a \code{data.frame} of the original csv WHO mortality table, this is the output of \code{\link{import_who}}
#'
#' @return a \code{data.frame} with snake case column names
#' @export
#'
#' @examples
#' \dontrun{
#' ccodes <- import_who(path = getwd(), data = "ccode")
#' names(ccodes)
#' ccodes <- snakecase_cols(ccodes)
#' names(ccodes)
#' }
snakecase_cols <- function(x) {
  stopifnot(!is.null(names(x)))
  stopifnot(is.data.frame(x))
  
  names(x) <- tolower(names(x))
  names(x) <- gsub("\\.", "_", names(x))
  return(x)
  
}