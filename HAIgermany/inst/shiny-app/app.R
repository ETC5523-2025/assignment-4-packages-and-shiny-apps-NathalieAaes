library(shiny)
library(plotly)
library(HAIgermany)


# CSS styling
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

# mapping each HAI to have its own color even when adding/removing
hai_colors <- c(
  "UTI" = "#a6cee3",
  "CDI" = "#b2df8a",
  "HAP" = "#fb9a99",
  "BSI" = "#fdbf6f",
  "SSI" = "#cab2d6"
)

# HAI type explanations
hai_descriptions <- c(
  "UTI" = "(Urinary Tract Infection): infection of the urinary system, often associated with catheter use",
  "CDI" = "(Clostridium difficile Infection): bacterial infection causing diarrhea, usually after antibiotic use",
  "HAP" = "(Hospital-Acquired Pneumonia): lung infection occurring during hospital stay",
  "BSI" = "(Bloodstream Infection): bacteria or fungi in the blood, often linked to central lines",
  "SSI" = "(Surgical Site Infection): infection at the site of a surgical incision"
)

# UI
ui <- fluidPage(
  tags$head(tags$style(HTML(custom_css))),
  titlePanel("HAI Data Explorer"),

  sidebarLayout(
    sidebarPanel(
      # Dataset selector
      selectInput(
        "dataset",
        "Choose dataset/plot:",
        choices = c("Stratified Infection Rates", "Patients at Risk")
      ),

      # HAI type checkboxes
      uiOutput("hai_selector"),

      # Explanatory text
      wellPanel(
        h4("Interpretation"),
        p("For each plot, the height of each bar indicates the number of patients."),
        p("• 'Stratified Infection Rates' shows the actual infection counts by age group.
          This helps identify which age groups are most affected by each HAI."),
        p("• 'Patients at Risk' shows the total number of patients who could potentially develop each HAI.
          Comparing this with actual infection counts can highlight which infections are more or less common relative to the population at risk. See the vignette for more explanation."),
        p("• You can select specific HAI types using the checkboxes to focus on patterns of interest.
          Look for differences between age groups and across infection types to understand the distribution of risk in German healthcare settings."),

        h4("Variable description"),
        p(strong("Age Group:"), "Ranges of patient ages."),
        p(strong("Infection:"), "Type of healthcare-associated infection (HAI), e.g., UTI, CDI."),
        uiOutput("count_description"),

        h4("HAI Type Explanations"),
        tags$ul(
          lapply(names(hai_descriptions), function(x) {
            tags$li(paste0(x, ": ", hai_descriptions[x]))
          })
        )
      )
    ),

    mainPanel(
      plotlyOutput("main_plot")
    )
  )
)

# Server
server <- function(input, output, session) {

  # HAI type selector UI
  output$hai_selector <- renderUI({
    if (input$dataset == "Stratified Infection Rates") {
      hai_choices <- sort(unique(num_hai_patients_tidy$Infection))
      checkboxGroupInput(
        "hai_types",
        "Select HAI types:",
        choices = hai_choices,
        selected = intersect(hai_choices, c("UTI", "CDI"))
      )
    } else if (input$dataset == "Patients at Risk") {
      hai_choices <- sort(unique(mccabe_scores_distr_tidy$Infection))
      checkboxGroupInput(
        "hai_types_mccabe",
        "Select HAI types:",
        choices = hai_choices,
        selected = intersect(hai_choices, c("UTI", "CDI"))
      )
    }
  })

  # Dynamic description for counts variable
  output$count_description <- renderUI({
    if (input$dataset == "Stratified Infection Rates") {
      p(strong("Number of Cases:"), "Number of patients who actually had that HAI in the specified age group.")
    } else if (input$dataset == "Patients at Risk") {
      p(strong("Patients at Risk:"), "Number of patients at risk of that HAI in the specified age group.")
    }
  })

  # Main plot
  output$main_plot <- renderPlotly({

    if (input$dataset == "Stratified Infection Rates") {

      data_plot <- num_hai_patients_tidy %>%
        filter(Infection %in% input$hai_types)

      plot_ly(
        data_plot,
        x = ~AgeGroup, y = ~TotalCases,
        color = ~Infection, colors = hai_colors, type = "bar"
      ) %>%
        layout(
          barmode = "group",
          title = "Stratified Infection Rates by Age Group",
          xaxis = list(title = "Age Group"),
          yaxis = list(title = "Number of Cases")
        )

    } else if (input$dataset == "Patients at Risk") {

      data_plot <- mccabe_scores_distr_tidy %>%
        filter(Infection %in% input$hai_types_mccabe)

      plot_ly(
        data_plot,
        x = ~AgeGroup, y = ~PatientsAtRisk,
        color = ~Infection, colors = hai_colors, type = "bar"
      ) %>%
        layout(
          barmode = "group",
          title = "Patients at Risk by Age Group",
          xaxis = list(title = "Age Group"),
          yaxis = list(title = "Patients at Risk")
        )
    }
  })
}


shinyApp(ui, server)
