% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/football_get_teams.R
\name{football_get_teams}
\alias{football_get_teams}
\title{Get competition information}
\usage{
football_get_teams(
  competition_id = NULL,
  api = "football-data.org",
  api_token = Sys.getenv("API_FOOTBALL_DATA")
)
}
\arguments{
\item{competition_id}{The id for that competition. Optional}

\item{api}{Name of API. Currently has \code{"football-data.org"}}

\item{api_token}{The API token.}
}
\value{
Base url for API
}
\description{
Get either information on what competitions exist, or a particular
competition.
}
\examples{
football_api_url("football-data.org")

}
