#' Get upcoming matches
#'
#' Hits the matches API fixed on \code{status=SCHEDULED}.
#'
#' @param team_id What is the team id
#' @param api Which API to use.
#' @param api_token Your API token.
#'
#' @return Base url for API
#'
#' @examples
#' football_api_url()
#'
#' @export
football_get_upcoming <- function(
  team_id = 86,
  api = "football-data.org",
  api_token = Sys.getenv("API_FOOTBALL_DATA")
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
