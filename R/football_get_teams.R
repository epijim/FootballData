#' Get competition information
#'
#' Get either information on what competitions exist, or a particular
#' competition.
#'
#' @param api Name of API. Currently has \code{"football-data.org"}
#' @param api_token The API token.
#' @param competition_id The id for that competition. Optional
#'
#' @return Base url for API
#'
#' @examples
#' football_api_url("football-data.org")
#'
#' @export
football_get_teams <- function(
  competition_id = NULL,
  api = "football-data.org",
  api_token = Sys.getenv("API_FOOTBALL_DATA")
){
  # allow later api's to be added
  api_endpoint <- switch(
    api,
    "football-data.org" = glue::glue("competitions/{competition_id}/teams")
  )

  # get the data
  data <- football_pull(
    api = api,
    api_endpoint = api_endpoint,
    api_token = api_token)


  # clean football-data.org
  data_clean <- data$teams %>%
    dplyr::select(
      team_id = id,
      team = name,
      team_short = shortName,
      url_team = crestUrl
    )


  data_clean
}
