#' WHO Population Data Dictionary
#'
#' Data dictionary for the population raw files extracted from the 
#' documentation Word document "Documentation_1May2019.doc"
#'
#' @docType data
#'
#' @usage data(dd_pop)
#'
#' @format A \code{data.frame} object containing the column names and descriptions
#' for the population data table "pop"
#' \describe{
#'   \item{column_name}{the column name used for the WHO population table}
#'   \item{content}{the description of the column name}
#'   \item{type}{expected data type for the column}
#' }
#'
#' @keywords datasets
#'
#' @source \href{https://www.who.int/healthinfo/statistics/mortality_rawdata/en/}{WHO Mortality Database}
#'
#' @examples
#' data(dd_pop)
#' head(dd_pop)
"dd_pop"
