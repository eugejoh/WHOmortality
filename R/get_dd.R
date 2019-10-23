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

# get_dd(type = "mort")