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
football_get_competition <- function(
  competition_id = NULL,
  api = "football-data.org",
  api_token = Sys.getenv("API_FOOTBALL_DATA")
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
  if (is.null(competition_id)){
    data_clean <- data$competitions

    data_clean <- data_clean %>%
      dplyr::mutate(
        country = area,
        league = name,
        competition_id = id
      )

    data_clean <- dplyr::bind_cols(
      data_clean %>%
        dplyr::select(league,competition_id,plan),
      data_clean$area %>%
        dplyr::select(country = name, url_flag = ensignUrl)
    ) %>%
      dplyr::mutate(
        flag = dplyr::case_when(
          !is.na(url_flag) ~ glue::glue("<img src='{url_flag}' height='24'></img>"),
          TRUE ~ NA_character_
        )
      )

  } else {
    data_clean <- data
  }


  data_clean
}
