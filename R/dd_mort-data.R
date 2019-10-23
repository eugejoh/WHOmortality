#' WHO Mortality Data Dictionary
#'
#' Data dictionary for the mortality raw files extracted from the 
#' documentation Word document "Documentation_1May2019.doc"
#'
#' @docType data
#'
#' @usage data(dd_mort)
#'
#' @format A \code{data.frame} object containing the column names and descriptions
#' for the mortality data tables "Morticd10_part1" and "Morticd10_part2"
#' \describe{
#'   \item{column_name}{the column name used for the WHO mortality table}
#'   \item{content}{the description of the column name}
#'   \item{type}{expected data type for the column}
#' }
#' 
#' @keywords datasets
#'
#' @source \href{https://www.who.int/healthinfo/statistics/mortality_rawdata/en/}{WHO Mortality Database}
#'
#' @examples
#' data(dd_mort)
#' head(dd_mort)
"dd_mort"