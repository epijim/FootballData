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
football_get_upcoming <- function(
  team_id = 86,
  api = "football-data.org",
  api_token = Sys.getenv("MY_SECRET")
){
  # allow later api's to be added
  api_endpoint <- switch(
    api,
    "football-data.org" = glue::glue("teams/{team_id}/matches?status=SCHEDULED")
  )

  # get the data
  data <- football_pull(
    api = api,
    api_endpoint = api_endpoint,
    api_token = api_token)

  # clean football-data.org
  data_clean <- data$matches

  data_clean
}
