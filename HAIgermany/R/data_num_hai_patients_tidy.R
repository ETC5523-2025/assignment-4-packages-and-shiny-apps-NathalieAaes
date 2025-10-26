#' Number of HAI Patients by Age Group
#'
#' A tidy dataset containing the total number of patients per age group for each
#' type of healthcare-associated infection (HAI). Each row represents a unique
#' combination of age group and infection type, with the corresponding total
#' number of patients.
#'
#' @format A tibble with columns:
#' \describe{
#'   \item{AgeGroup}{Age group of the patients (e.g., "20-24", "25-29")}
#'   \item{Infection}{Type of healthcare-associated infection (e.g., "UTI", "SSI")}
#'   \item{TotalCases}{Total number of patients in that age group with that infection type}
#' }
#' @source BHAI dataset
"num_hai_patients_tidy"
