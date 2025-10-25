library(shiny)
library(dplyr)
library(tidyr)
library(plotly)
library(BHAI)
library(purrr)
library(tibble)

ui <- fluidPage(
  titlePanel("HAI Data Explorer"),

  sidebarLayout(
    sidebarPanel(
      selectInput(
        "dataset",
        "Choose dataset/plot:",
        choices = c("Stratified Infection Rates", "McCabe Score Distribution")
      ),
      uiOutput("hai_selector")
    ),

    mainPanel(
      plotlyOutput("main_plot")
    )
  )
)

server <- function(input, output, session) {
  output$hai_selector <- renderUI({
    if(input$dataset == "Stratified Infection Rates") {
      checkboxGroupInput(
        "hai_types",
        "Select HAI types:",
        choices = names(BHAI::num_hai_patients_by_stratum),
        selected = names(BHAI::num_hai_patients_by_stratum)
      )
    } else if(input$dataset == "McCabe Score Distribution") {
      checkboxGroupInput(
        "hai_types_mccabe",
        "Select HAI types:",
        choices = names(BHAI::mccabe_scores_distr),
        selected = names(BHAI::mccabe_scores_distr)
      )
    }
  })


    output$main_plot <- renderPlotly({
    if(input$dataset == "Stratified Infection Rates") {
      df <- purrr::imap_dfr(BHAI::num_hai_patients_by_stratum, function(mat, infection) {
        as.data.frame(mat) %>%
          tibble::rownames_to_column("AgeGroup") %>%
          pivot_longer(-AgeGroup, names_to = "Gender", values_to = "Cases") %>%
          mutate(Infection = infection)
      }) %>% filter(Infection %in% input$hai_types)

      age_levels <- rownames(BHAI::num_hai_patients_by_stratum[[1]])
      df$AgeGroup <- factor(df$AgeGroup, levels = age_levels, ordered = TRUE)

      plot_ly(df, x = ~AgeGroup, y = ~Cases, color = ~Gender, type = "bar") %>%
        layout(barmode = "stack", title = "Stratified Infection Counts")

    } else if(input$dataset == "McCabe Score Distribution") {
      df <- purrr::imap_dfr(BHAI::mccabe_scores_distr, function(mat, infection) {
        as.data.frame(mat) %>%
          tibble::rownames_to_column("AgeGroup") %>%
          pivot_longer(-AgeGroup, names_to = "Gender", values_to = "Cases") %>%
          mutate(Infection = infection)
      }) %>% filter(Infection %in% input$hai_types_mccabe)

      df <- df %>%
        mutate(AgeLow = as.numeric(gsub("\\[(\\d+),.*\\]", "\\1", AgeGroup))) %>%
        arrange(AgeLow) %>%
        mutate(AgeGroup = factor(AgeGroup, levels = unique(AgeGroup), ordered = TRUE))

      plot_ly(df, x = ~AgeGroup, y = ~Cases, color = ~Gender, type = "bar") %>%
        layout(barmode = "stack", title = "McCabe Score Distribution (Filtered by HAI Type)")
    }
  })
}

shinyApp(ui, server)
