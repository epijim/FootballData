## Get data from football-data.co.uk

library(tidyverse)
library(glue)

url_base <- "https://www.football-data.co.uk/mmz4281/"

## Data of interest ---------------------------

leagues <- tribble(
  ~country,    ~league,           ~code,   ~tier,
  "England",   "Premier League",  "E",     0,
  "England",   "Championship",    "E",     1,
  "Germany",   "Bundesliga",      "D",     1,
  "Germany",   "2. Bundesliga",   "D",     2,
  "Scotland",  "Premier League",  "SC",     0,
  "Scotland",  "Championship",    "SC",     1
)

## Helper function ----------------------------
# to get odds

get_odds <- function(
  year = 21, # two digit for year season ends in
  x = leagues # leagues data
){
  lookup <- x %>%
    mutate(
      url = glue("{url_base}{year-1}{year}/{code}{tier}.csv")
    )

  data <- NULL
  for (i in 1:nrow(lookup)){
    i_lookup <- lookup %>% slice(i)

    i_data <- read_csv(
      i_lookup$url,
      col_types = cols(
        Div = col_character(),
        Date = col_date(format = "%d/%m/%Y"),
        Time = col_time(format = ""),
        HomeTeam = col_character(),
        AwayTeam = col_character(),
        FTR = col_character(),
        HTR = col_character(),
        Referee = col_character()
      )
    ) %>%
      mutate(
        country = i_lookup$country,
        league = i_lookup$league,
        season_ended = year
      ) %>%
      select(
        country,
        league,
        season_ended,
        date = Date,
        team_home = HomeTeam,
        team_away = AwayTeam,
        result = FTR,
        average_odds_home = AvgH,
        average_odds_draw = AvgD,
        average_odds_away = AvgA
      )

    data <- bind_rows(i_data,data)
  }

  data
}

## Get a few years ----------------------------
football_odds <- 20:21 %>%
  map_df(get_odds)



## Save ---------------------------------------

usethis::use_data(football_odds, overwrite = TRUE)
