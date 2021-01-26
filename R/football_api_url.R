#' Map name to base URL for API
#'
#' Adding in as potentially may allow package to work over a few APIs
#'
#' @param api Name of API. Currently has \code{"football-data.org"}
#'
#' @return Base url for API
#'
#' @examples
#' FootballData:::football_api_url("football-data.org")
football_api_url <- function(api = "football-data.org"){
  switch(
    api,
    "football-data.org" = "https://api.football-data.org/v2/"
  )
}


