
library(glue)
library(tidyverse)
devtools::load_all()

select_country <- "England"
select_league <- "Championship"

#####  Competitions -----------------------------------------------------------

# Clean competitions ----------
competitions <- football_get_competition() %>%
  mutate(
    country = area,
    league = name,
    competition_id = id
  )

competitions <- bind_cols(
  competitions %>%
    select(league,competition_id),
  competitions$area %>%
    select(country = name, url_flag = ensignUrl)
  ) %>%
  mutate(
    flag = case_when(
      !is.na(url_flag) ~ glue("<img src='{url_flag}' height='24'></img>"),
      TRUE ~ NA_character_
    )
  )

competitions_curated <- competitions %>%
  filter(
    league %in% unique(FootballData::football_odds$league) &
      country %in% unique(FootballData::football_odds$country)
  )

# Tables
competition_table <- competitions  %>%
  select(country,flag,league,competition_id)

competition_table %>%
  DT::datatable(caption = "All leagues in API", escape = FALSE,
                rownames= FALSE)

competition_table %>%
  filter(
    league %in% unique(FootballData::football_odds$league) &
    country %in% unique(FootballData::football_odds$country)
  ) %>%
  knitr::kable(caption = "Leagues I mapped", escape = FALSE)


#####  A league------------------------------------------------------------------
league <- competitions_curated %>%
  filter(country == select_country & league == select_league) %>%
  pull(competition_id) %>%
  as.character() %>%
  football_get_teams() %>%
  mutate(
    crest = case_when(
      !is.na(url_team) ~ glue("<img src='{url_team}' height='24'></img>"),
      TRUE ~ NA_character_
    )
  )

# table
league %>%
  select(team,team_short,crest,team_id) %>%
  DT::datatable(caption = "Teams in this league",
                escape = FALSE,
                rownames= FALSE)

#####  Standings ----------------------------------------------------------------

standings <- competitions_curated %>%
  filter(country == "England" & league == "Championship") %>%
  pull(competition_id) %>%
  as.character() %>%
  football_get_standing()

standings <- bind_cols(
  standings %>%
    select(
      position,playedGames,form,won,draw,lost,points,
      goalsFor,goalsAgainst,goalDifference
      ),
  standings$team %>%
    select(team_id = id,team = name,url_team = crestUrl)  %>%
    mutate(
      crest = case_when(
        !is.na(url_team) ~ glue("<img src='{url_team}' height='24'></img>"),
        TRUE ~ NA_character_
      )
    )
)



# table
standings %>%
  select(position,team,crest,form,won, draw, lost, points) %>%
  DT::datatable(caption = "Teams in this league",
                escape = FALSE,
                rownames= FALSE)

##### Who's next ---------------------------------------------------------------
upcoming_foe_data <- standings %>%
  filter(
      team == team_interest
    ) %>%
  pull(team_id) %>%
  as.character() %>%
  football_get_upcoming() %>%
  arrange(utcDate) %>%
  slice(1)

upcoming_foe_date <- as.Date(upcoming_foe_data$utcDate)

upcoming_foe_team <- upcoming_foe_data %>%
  select(awayTeam) %>%
  pull(awayTeam) %>%
  pull(name)


#####  Mapping ----------------------------------------------------------------

selected_league <- FootballData::football_odds %>%
  filter(league == select_league & country == select_country)

unique_teams <- unique(c(selected_league$team_home,selected_league$team_away))

team_mapping <- tribble(
  ~team_api,                  ~team_pkg,
  # England - Championship
  "AFC Bournemouth",          "Bournemouth",
  "Barnsley FC",              "Barnsley",
  "Birmingham City FC",       "Birmingham",
  "Blackburn Rovers FC",      "Blackburn",
  "Brentford FC",             "Brentford",
  "Bristol City FC",          "Bristol City",
  "Cardiff City FC",          "Cardiff",
  "Coventry City FC",         "Coventry",
  "Derby County FC",          "Derby",
  "Huddersfield Town AFC",    "Huddersfield",
  "Luton Town FC",            "Luton",
  "Middlesbrough",            "Blackburn",
  "Millwall FC",              "Millwall",
  "Norwich City FC",          "Norwich",
  "Nottingham Forest FC",     "Nott'm Forest",
  "Preston North End FC",     "Preston",
  "Queens Park Rangers FC",   "QPR",
  "Reading FC",               "Reading",
  "Rotherham United FC",      "Rotherham",
  "Sheffield Wednesday FC",   "Sheffield Weds",
  "Stoke City FC",            "Stoke",
  "Swansea City AFC",         "Swansea",
  "Watford FC",               "Watford",
  "Wycombe Wanderers FC",     "Wycombe"
)

get_historical_perfomance <- function(
  team_interest = "Bristol City FC",
  team_foe = "Millwall FC",
  odds_data = FootballData::football_odds,
  remap_team_names = TRUE
){

  # remap from API to odds data format
    if (remap_team_names){
      team_interest_clean <- team_mapping %>%
        filter(team_api == team_interest) %>%
        pull(team_pkg)
      team_foe_clean <- team_mapping %>%
        filter(team_api == team_foe) %>%
        pull(team_pkg)
    } else {
      team_interest_clean <- team_interest
      team_foe_clean <- team_foe
    }


  odds_data %>%
    filter(
      team_home %in% c(team_interest_clean,team_foe_clean) &
        team_away %in% c(team_interest_clean,team_foe_clean)
    ) %>%
    arrange(desc(date)) %>%
    mutate(
      was_home = case_when(
        team_home == team_interest_clean ~ TRUE,
        TRUE ~ FALSE
      ),
      favourite = case_when(
        was_home & (average_odds_home <= average_odds_away) ~ TRUE, # T
        was_home & (average_odds_home > average_odds_away) ~ FALSE, # F
        !was_home & (average_odds_away <= average_odds_home) ~ TRUE, # T
        !was_home & (average_odds_away > average_odds_home) ~ FALSE # F
      ),
      favourite_percent = round(mean(favourite)*100,0),
      team_interest = team_interest,
      team_foe = team_foe
    ) %>%
    slice(1) %>%
    select(
      team_interest, team_foe, favourite, favourite_percent
    )
}

get_historical_perfomance()

get_historical_perfomance(
  team_interest = team_interest,
  team_foe = upcoming_foe_team
)


#####  Metrics ----------------------------------------------------------------
team_interest <- "Nottingham Forest FC"
d_standings <- standings

# d_standings
metrics_standing <- d_standings %>%
  mutate(
    metric_season_position = case_when(
      position == min(position) ~ "++++ Top of the league",
      position >= max(position) - 1 ~ "---- Relagation?",
      position / max(position) < 0.2 ~ "++ Strong league position",
      position / max(position) < 0.5 ~ "+ Safe in middle of league",
      position / max(position) < 0.8 ~ "- So so season",
      position / max(position) < 1.1 ~ "-- Poor season",
    ),
    metric_recent_wins = case_when(
      str_count(form,"W") == 5 ~ "++++ 5 win streak",
      str_count(form,"L") == 5 ~ "---- 5 loss streak",
      str_count(form,"W") >= 3 ~ "++ recent wins",
      str_count(form,"L") < 1 ~ "+ only one recent loss",
      str_count(form,"W") == 0 ~ "-- no recent wins",
      str_sub(form,-1) == "W" ~ "+ won last game",
      str_count(form,"L") >= 3 ~ "-- more recent losses than wins",
      str_sub(form,-1) == "L" ~ "- lost last game",
      str_sub(form,-1) == "D" ~ "drew last game",
      TRUE ~ "recent performance uncategorised"
    ),
    working = sd(goalDifference),
    metric_back_of_net = case_when(
      goalDifference > sd(goalDifference) ~ "+++ strikers are on form",
      goalDifference < -sd(goalDifference) ~ "--- defense is a seive",
      goalDifference > 0 ~ "+ scored more than conceded",
      goalDifference < 0 ~ "- conceded more than scored",
      goalDifference == 0 ~ "one goal for every one conceded",
      TRUE ~ "recent goal difference uncategorised"
    ),
    # metric_back_of_net = case_when(
    #
    # )
  ) %>%
  select(
    team,starts_with("metric")
  )

# odds next game
  get_historical_perfomance(
    team_interest = team_interest,
    team_foe = upcoming_foe_team
    ) %>%
    mutate(
      metric_odds = case_when(
        favourite_percent < 40 ~ glue("-- Next match is with {upcoming_foe_team} ({upcoming_foe_date}), and bookies have had them as favourites {favourite_percent}% of the time in recent games."),
        favourite_percent < 60 ~ glue("Next match is with {upcoming_foe_team} ({upcoming_foe_date}), and bookies have had them as favourites {favourite_percent}% of the time in recent games."),
        favourite_percent < 101 ~ glue("++ Next match is with {upcoming_foe_team} ({upcoming_foe_date}), and bookies have had them as favourites {favourite_percent}% of the time in recent games.")
      )
    )



