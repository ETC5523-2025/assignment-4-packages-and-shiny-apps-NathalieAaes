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

# UI
ui <- fluidPage(
  tags$head(tags$style(HTML(custom_css))),  # applying styling
  titlePanel("🦠 HAI Data Explorer"),

  sidebarLayout(
    sidebarPanel(
      # dataset selector
      selectInput(
        "dataset",
        "Choose dataset/plot:",
        choices = c("Stratified Infection Rates", "McCabe Score Distribution")
      ),

      # checkboxes for selecting which HAI types to show
      uiOutput("hai_selector"),

      # Explanatory text
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

# Server
server <- function(input, output, session) {

  # HAI type checkboxes
  output$hai_selector <- renderUI({
    if (input$dataset == "Stratified Infection Rates") {
      hai_choices <- sort(unique(num_hai_patients_tidy$Infection))
      checkboxGroupInput(
        "hai_types",
        "Select HAI types:",
        choices = hai_choices,
        selected = intersect(hai_choices, c("UTI", "CDI"))
      )
    } else if (input$dataset == "McCabe Score Distribution") {
      hai_choices <- sort(unique(mccabe_scores_distr_tidy$Infection))
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

      # filter dataset by selected HAI types
      num_hai_patients <- num_hai_patients_tidy %>%
        filter(Infection %in% input$hai_types)

      # the barplot itself
      plot_ly(num_hai_patients,
              x = ~AgeGroup, y = ~TotalCases,
              color = ~Infection, colors = hai_colors, type = "bar") %>%
        layout(barmode = "group",
               title = "Stratified Infection Rates by Age Group",
               xaxis = list(title = "Age Group"),
               yaxis = list(title = "Number of Cases"))

    } else if (input$dataset == "McCabe Score Distribution") {

      # filter dataset by selected HAI types
      mccabe_scores_distr <- mccabe_scores_distr_tidy %>%
        filter(Infection %in% input$hai_types_mccabe)

      # the barplot itself
      plot_ly(mccabe_scores_distr,
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
