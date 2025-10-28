library(dplyr)
library(purrr)
library(tibble)
library(BHAI)
library(tidyr)



num_hai_patients_tidy <- purrr::imap_dfr(BHAI::num_hai_patients_by_stratum, function(mat, infection) {
  as.data.frame(mat) %>%
    tibble::rownames_to_column("AgeGroup") %>%
    pivot_longer(-AgeGroup, names_to = "Gender", values_to = "Cases") %>%
    group_by(AgeGroup) %>%
    summarise(TotalCases = sum(Cases, na.rm = TRUE), .groups = "drop") %>%
    mutate(Infection = infection)
})

#ordering of the age-intervals to make sure [5,9] isn't between [45,49] and [50,54]
age_levels <- rownames(BHAI::num_hai_patients_by_stratum[[1]])
num_hai_patients_tidy$AgeGroup <- factor(num_hai_patients_tidy$AgeGroup, levels = age_levels, ordered = TRUE)



mccabe_scores_distr_tidy <- purrr::imap_dfr(BHAI::mccabe_scores_distr, function(mat, infection) {
  as.data.frame(mat) %>%
    tibble::rownames_to_column("AgeGroup") %>%
    pivot_longer(-AgeGroup, names_to = "Gender", values_to = "Cases") %>%
    group_by(AgeGroup) %>%
    summarise(PatientsAtRisk = sum(Cases, na.rm = TRUE), .groups = "drop") %>%
    mutate(Infection = infection)})

mccabe_scores_distr_tidy <- mccabe_scores_distr_tidy %>%
  mutate(AgeLow = as.numeric(gsub("\\D*(\\d+).*", "\\1", AgeGroup))) %>%
  arrange(AgeLow) %>%
  mutate(AgeGroup = factor(AgeGroup, levels = unique(AgeGroup), ordered = TRUE)) %>%
  select(-AgeLow)



#### Save datasets if needed ####
usethis::use_data(num_hai_patients_tidy, mccabe_scores_distr_tidy, overwrite = TRUE)
devtools::install(".", force = TRUE)
