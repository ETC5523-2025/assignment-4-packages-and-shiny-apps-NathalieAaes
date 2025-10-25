## code to prepare `DATASET` dataset goes here

install.packages("BHAI")
library(BHAI)

data(package = "BHAI")

library(BHAI)

head(num_hai_patients)
head(num_survey_patients)
head(length_of_stay)
head(BHAI::population)




usethis::use_data(DATASET, overwrite = TRUE)
