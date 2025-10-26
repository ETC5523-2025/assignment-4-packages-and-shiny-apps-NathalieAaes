library(shiny)
library(dplyr)
library(tidyr)
library(plotly)
library(BHAI)
library(purrr)
library(tibble)
library(RColorBrewer)

# styling
custom_css <- "
body {
  background-color: #F9FFFF;
  color: #002C3B !important;
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
}
h1, h2, h3, .title-panel {
  color: #0078A1 !important;
  font-weight: 600;
}
.well, .sidebar, #main_plot {
  background-color: #ffffff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  border: none;
  padding: 12px;
}
.form-group label {
  font-weight: 500;
  color: #002C3B;
}
.btn, .selectize-input, .checkbox {
  border-radius: 8px !important;
}
#main_plot {
  padding: 10px;
}
"


# mapping each hai to have its own color even when adding and removing other hai's
hai_colors <- c(
  "UTI" = "#a6cee3",
  "CDI" = "#b2df8a",
  "HAP" = "#fb9a99",
  "BSI" = "#fdbf6f",
  "SSI" = "#cab2d6"
)



ui <- fluidPage(
  tags$head(tags$style(HTML(custom_css))),  #applying the styling
  titlePanel("🦠 HAI Data Explorer"),

  sidebarLayout(
    sidebarPanel(
      #to be edited
      selectInput(
        "dataset",
        "Choose dataset/plot:",
        choices = c("Stratified Infection Rates", "McCabe Score Distribution")
      ),

      # checkboxes for selecting which HAI types to show
      uiOutput("hai_selector"),

      #Explanatory text
      wellPanel(
        h4("Interpretation"),
        p("For each plot, the height of each bar indicates the number of patients.
          For 'Stratified Infection Rates', bars represent counts per age group.
          For 'McCabe Score Distribution', bars show counts per age group for different HAIs."),

        h4("Variable description"),
        p(strong("AgeGroup:"), "Ranges of patient ages."),
        p(strong("Infection:"), "Type of healthcare-associated infection (HAI), e.g., UTI, CDI."),
        p(strong("Cases / TotalCases:"), "Number of patients with that HAI in the specified age group.")
      )
    ),

    mainPanel(
      plotlyOutput("main_plot")
    )
  )
)


server <- function(input, output, session) {

  #checkboxes
  output$hai_selector <- renderUI({
    if (input$dataset == "Stratified Infection Rates") {
      hai_choices <- sort(names(BHAI::num_hai_patients_by_stratum))
      checkboxGroupInput(
        "hai_types",
        "Select HAI types:",
        choices = hai_choices,
        selected = intersect(hai_choices, c("UTI", "CDI"))  # selection of CDI and UTI as default. These have a big difference
      )
    } else if (input$dataset == "McCabe Score Distribution") {
      hai_choices <- sort(names(BHAI::mccabe_scores_distr))
      checkboxGroupInput(
        "hai_types_mccabe",
        "Select HAI types:",
        choices = hai_choices,
        selected = intersect(hai_choices, c("UTI", "CDI"))
      )
    }
  })

  ####Plot 1: Stratified Infection Rates####
  output$main_plot <- renderPlotly({
    if (input$dataset == "Stratified Infection Rates") {

      # to be edited
      df <- purrr::imap_dfr(BHAI::num_hai_patients_by_stratum, function(mat, infection) {
        as.data.frame(mat) %>%
          tibble::rownames_to_column("AgeGroup") %>%
          pivot_longer(-AgeGroup, names_to = "Gender", values_to = "Cases") %>%
          group_by(AgeGroup) %>%
          summarise(TotalCases = sum(Cases, na.rm = TRUE), .groups = "drop") %>%
          mutate(Infection = infection)
      }) %>%
        filter(Infection %in% input$hai_types)  # filter by selected hai types in checkboxes

      #ordering of the age-intervals to make sure [5,9] isn't between [45,49] and [50,54]
      age_levels <- rownames(BHAI::num_hai_patients_by_stratum[[1]])
      df$AgeGroup <- factor(df$AgeGroup, levels = age_levels, ordered = TRUE)

      # the barplot itself
      plot_ly(df,
              x = ~AgeGroup, y = ~TotalCases,
              color = ~Infection, colors = hai_colors, type = "bar") %>%
        layout(barmode = "group",
               title = "Stratified Infection Rates by Age Group",
               xaxis = list(title = "Age Group"),
               yaxis = list(title = "Number of Cases"))

      ####Plot 2: McCabe Score Distribution####

    } else if (input$dataset == "McCabe Score Distribution") {

      # to be edited
      df <- purrr::imap_dfr(BHAI::mccabe_scores_distr, function(mat, infection) {
        as.data.frame(mat) %>%
          tibble::rownames_to_column("AgeGroup") %>%
          pivot_longer(-AgeGroup, names_to = "Gender", values_to = "Cases") %>%
          group_by(AgeGroup) %>%
          summarise(TotalCases = sum(Cases, na.rm = TRUE), .groups = "drop") %>%
          mutate(Infection = infection)
      }) %>%
        filter(Infection %in% input$hai_types_mccabe)

      df <- df %>%
        mutate(AgeLow = as.numeric(gsub("\\D*(\\d+).*", "\\1", AgeGroup))) %>%
        arrange(AgeLow) %>%
        mutate(AgeGroup = factor(AgeGroup, levels = unique(AgeGroup), ordered = TRUE))

      # the plot itself
      plot_ly(df,
              x = ~AgeGroup, y = ~TotalCases,
              color = ~Infection, colors = hai_colors, type = "bar") %>%
        layout(barmode = "group",
               title = "McCabe Score Distribution by Age Group",
               xaxis = list(title = "Age Group"),
               yaxis = list(title = "Number of Cases"))
    }
  })
}


shinyApp(ui, server)
