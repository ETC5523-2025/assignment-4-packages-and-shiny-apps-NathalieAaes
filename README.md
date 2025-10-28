
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HAIgermany 🦠

[![Pkgdown](https://img.shields.io/badge/pkgdown-website-blue)](https://etc5523-2025.github.io/assignment-4-packages-and-shiny-apps-NathalieAaes/)

HAIgermany is an R package designed to explore and visualize
healthcare-associated infections (HAIs) in Germany. It includes tidy
datasets and analysis functions, along with an interactive Shiny app
that allows users to filter by infection type and view stratified
infection rates and McCabe score distributions. The data originates from
the BHAI R package, which is based on the ECDC Point Prevalence Survey
(2011–2012).

------------------------------------------------------------------------

## Installation

You can install HAIgermany from GitHub:

``` r
# Install remotes if needed
# install.packages("remotes")

# Install HAIgermany
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-NathalieAaes/HAIgermany")
```

------------------------------------------------------------------------

## Example Usage

### Load package and run the Shiny app:

``` r
library(HAIgermany)

# Launch the interactive HAI Explorer app
run_HAIgermany_app()
```

### Explore datasets:

- `num_hai_patients_tidy`: Number of patients who actually had a
  healthcare-associated infection (HAI), broken down by age group and
  infection type. These are the observed HAI cases in the PPS survey.
- `mccabe_scores_distr_tidy`: The counts include all patients in the PPS
  survey who were at risk of that specific infection, not just those who
  became infected.

``` r
# Number of HAI patients by infection type and unit
head(num_hai_patients_tidy)

# Distribution of McCabe scores
head(mccabe_scores_distr_tidy)
```

------------------------------------------------------------------------

## Documentation

Full function and dataset documentation is available on the pkgdown
site:
[HAIgermany](https://etc5523-2025.github.io/assignment-4-packages-and-shiny-apps-NathalieAaes/).
