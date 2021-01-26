#' Internal function that does the pull
#'
#' Adding in as potentially may allow package to work over a few APIs,
#' and this step is done over multiple functions.
#'
#' @param api Name of API. Currently has \code{"football-data.org"}
#' @param api_endpoint Which API are you using.
#' @param api_token The API token.
#'
#' @return Base url for API
#'
#' @examples
#' # Will error as no API token
#' FootballData:::football_api_url("football-data.org")
football_pull <- function(
  api = "football-data.org",
  api_endpoint = "/competitions/",
  api_token = Sys.getenv("API_FOOTBALL_DATA")
){
  httr::GET(
    glue::glue("{football_api_url(api = api)}{api_endpoint}"),
    httr::add_headers("X-Auth-Token" = api_token)
    ) %>% httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()
}
