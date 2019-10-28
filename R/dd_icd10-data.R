#' ICD-10 Mortality Data Dictionary
#'
#' Data dictionary for the ICD-10 codes used in the mortality table, extracted from Table 8 in the
#' documentation Word document "Documentation_1May2019.doc"
#'
#' @docType data
#'
#' @usage data(dd_icd10)
#'
#' @format A \code{data.frame} object containing the column names and descriptions
#' for the ICD-10 code table "mort"
#' \describe{
#'   \item{code}{code used in the mortality table}
#'   \item{detailed}{detailed ICD-10 code list}
#'   \item{cause}{general cause of death}
#' }
#'
#' @keywords datasets
#'
#' @source \href{https://www.who.int/healthinfo/statistics/mortality_rawdata/en/}{WHO Mortality Database}
#'
#' @examples
#' data(dd_ic10)
#' head(dd_icd10)
"dd_icd10"