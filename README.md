
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HAIgermany 🦠

[![Pkgdown](https://img.shields.io/badge/pkgdown-website-blue)](https://etc5523-2025.github.io/assignment-4-packages-and-shiny-apps-NathalieAaes/)

HAIgermany is an R package for exploring and visualizing
healthcare-associated infections (HAIs) in Germany. It provides tidy
datasets, analysis functions, and an interactive Shiny app based on data
from the ECDC Point Prevalence Survey (2011–2012).

------------------------------------------------------------------------

## Installation

You can install the development version of HAIgermany from GitHub:

``` r
# Install remotes if needed
# install.packages("remotes")

# Install HAIgermany
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-NathalieAaes/HAIgermany")
#> Using GitHub PAT from the git credential store.
#> Skipping install of 'HAIgermany' from a github remote, the SHA1 (5765f04f) has not changed since last install.
#>   Use `force = TRUE` to force installation
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

``` r
# Distribution of McCabe scores
head(mccabe_scores_distr_tidy)

# Number of HAI patients by infection type and unit
head(num_hai_patients_tidy)
```

------------------------------------------------------------------------

## Documentation

Full function and dataset documentation is available on the pkgdown
site: [HAIgermany pkgdown
site](https://etc5523-2025.github.io/assignment-4-packages-and-shiny-apps-NathalieAaes/)
