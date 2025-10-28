#' Launch the HAIgermany Shiny App
#'
#' This function launches the interactive Shiny application included in the
#' HAIgermany package. The app allows users to explore healthcare-associated
#' infections (HAIs) in Germany, filter by infection type and age group, and
#' visualize McCabe score distributions interactively.
#'
#' @details
#' The app requires an interactive R session (e.g., RStudio or R GUI). It
#' automatically opens in a browser or the RStudio Viewer pane. If the app
#' directory cannot be found, an error is thrown suggesting reinstallation.
#'
#' @return Runs the Shiny app in a new window.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   run_HAIgermany_app()
#' }
#' }
run_HAIgermany_app <- function() {
  app_dir <- system.file("shiny-app", package = "HAIgermany")
  if (app_dir == "") {
    stop("Could not find Shiny app directory. Try reinstalling the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
