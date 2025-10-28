# HAIgermany 🦠

Welcome to the **HAIgermany** R package - a toolkit for exploring and visualizing
**healthcare-associated infections (HAIs)** in Germany.

This package provides tidy datasets, analysis functions, and an interactive Shiny
application based on data from the **ECDC Point Prevalence Survey (2011–2012)**.

---

## What’s inside

### Datasets
- `num_hai_patients_tidy`: Number of patients who actually had a healthcare-associated infection (HAI), broken down by age group and infection type.
- `mccabe_scores_distr_tidy`: The counts include all patients in the PPS survey who were at risk of that specific infection, not just those who became infected. For example, patients at risk of surgical site infections (SSI) are only those who underwent surgery, while patients at risk of urinary tract infections (UTI) are those with a urinary catheter.


Each dataset is tidy and ready for analysis or visualization.

### Installation

To install the package directly from GitHub:

```r
# Install the remotes package if needed
install.packages("remotes")

# Then install HAIgermany
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-NathalieAaes/HAIgermany")
```


### Shiny App
Launch the interactive HAI Explorer app:

```r
library(HAIgermany)
run_HAIgermany_app()
```

Use the app to filter infections, explore age distributions, and visualize McCabe score patterns interactively.


### Learn More

Explore the documentation and examples through the navigation bar above:

- **Reference**: function and dataset documentation
- **Vignettes**: [**]
