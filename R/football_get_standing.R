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

football_get_standing <- function(
  competition_id = 2021,
  api = "football-data.org",
  api_token = Sys.getenv("MY_SECRET")
){
  api_endpoint <- switch(
    api,
    "football-data.org" = glue::glue("competitions/{competition_id}/standings")
  )

  # get the data
  data <- football_pull(
    api = api,
    api_endpoint = api_endpoint,
    api_token = api_token)

  data_clean <- data$standings$table[[1]]

  data_clean
}
