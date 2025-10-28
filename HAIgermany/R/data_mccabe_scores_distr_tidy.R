#' McCabe Score Distribution by Age Group and Infection Type
#'
#' A tidy dataset summarizing the distribution of McCabe scores across different
#' age groups and types of healthcare-associated infections (HAIs). Each row
#' represents a unique combination of age group and infection type, with the total
#' number of patients at risk of that infection in that age group.
#'
#' Note that the counts represent patients at risk, not only those who actually
#' developed the infection. For example, patients at risk of surgical site infections
#' (SSI) are only those who underwent surgery, while patients at risk of urinary
#' tract infections (UTI) are those with a urinary catheter.
#'
#' @format A tibble with columns:
#' \describe{
#'   \item{AgeGroup}{Age group of the patients (e.g., "20-24", "25-29")}
#'   \item{Infection}{Type of healthcare-associated infection (e.g., "UTI", "SSI")}
#'   \item{PatientsAtRisk}{Number of patients at risk for that infection in the age group}
#' }
#' @source BHAI dataset (ECDC Point Prevalence Survey 2011–2012)
"mccabe_scores_distr_tidy"
