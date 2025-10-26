#' Launch the HAIgermany Shiny App
#'
#' This function launches the interactive Shiny app included in the HAIgermany package.
#'
#' @return Runs the Shiny app in a new window.
#' @export
#' @examples
#' if (interactive()) {
#'   run_HAIgermany_app()
#' }
run_HAIgermany_app <- function() {
  app_dir <- system.file("shiny-app", package = "HAIgermany")
  if (app_dir == "") {
    stop("Could not find Shiny app directory. Try reinstalling the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
