#' Import Data Dictionary for WHO Mortality and Population Tables
#' 
#' This function imports the data dictionaries for the mortality and population tables. These were extracted from the documentation word document "Documentation_1May2019.doc".
#'
#' @param type a single \code{character} specifying to import either the mortality or population data dictionary
#' @param ... other parameters pass to \code{\link{read_csv}}.
#'
#' @return a \code{data.frame} of the data dictionary with mappings of field names and descriptions
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' get_dd(type = "mort")
#' get_dd(type = "pop")
#' }
get_dd <- function(type = c("mort", "pop"), ...) {
  csv_files <- list.files(here::here("data"),
                          pattern = "\\.csv$",
                          full.names = TRUE)
  
  .dd_file <- function(files, type) {
    files[grepl(paste0("/dd_", type, ".*\\.csv$"), files)]
    }
  
  if (length(type) > 1) type <- type[1]
  dd <- .dd_file(csv_files, type)
  
  readr::read_csv(dd, ...)
}
