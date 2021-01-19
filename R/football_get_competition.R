#' Map name to base URL for API
#'
#' Adding in as potentially may allow package to work over a few APIs
#'
#' @param api Name of API. Currently has \code{"football-data.org"}
#'
#' @return Base url for API
#'
#' @examples
#' football_api_url("football-data.org")
#'
#' @export
football_get_competition <- function(
  api = "football-data.org",
  api_token = Sys.getenv("MY_SECRET"),
  competition_id = NULL
){
  # allow later api's to be added
  api_endpoint <- switch(
    api,
    "football-data.org" = glue::glue("/competitions/")
  )

  # If comp id given, add it
  if(!is.null(competition_id)) {
    api_endpoint <- glue::glue("{api_endpoint}{competition_id}")
  }

  # get the data
  data <- football_pull(
    api = api,
    api_endpoint = api_endpoint,
    api_token = api_token)

  # clean football-data.org
  data_clean <- data$competitions

  data_clean
}
