# HAIgermany 🦠

Welcome to the **HAIgermany** R package - a toolkit for exploring and visualizing
**healthcare-associated infections (HAIs)** in Germany.

This package provides tidy datasets, analysis functions, and an interactive Shiny
application based on data from the **ECDC Point Prevalence Survey (2011–2012)**.

---

## What’s inside

### Datasets
- `mccabe_scores_distr`: Distribution of McCabe scores by infection, age, and gender.  
- `num_hai_patients_tidy`: Number of HAI patients by infection type and unit.  

Each dataset is tidy and ready for analysis or visualization.

### Shiny App
Launch the interactive HAI Explorer app:

```r
library(HAIgermany)
run_HAIgermany_app()
```

Use the app to filter infections, explore age distributions, and visualize McCabe score patterns interactively.

### Installation

To install the package directly from GitHub:

```r
# Install the remotes package if needed
install.packages("remotes")

# Then install HAIgermany
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-NathalieAaes/HAIgermany")
```


### Learn More

Explore the documentation and examples through the navigation bar above:

- **Reference**: function and dataset documentation
- **Vignettes**: [**]








