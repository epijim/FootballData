
library(glue)
library(kableExtra)
library(tidyverse)
devtools::load_all()

select_country <- "England"
select_league <- "Championship"
select_team_interest <- "Nottingham Forest FC"

#####  Competitions -----------------------------------------------------------

# Clean competitions ----------
competitions <- football_get_competition()

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
  football_get_teams()

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


# table
standings %>%
  select(position,team,crest,form,won, draw, lost, points) %>%
  DT::datatable(caption = "Teams in this league",
                escape = FALSE,
                rownames= FALSE)

##### Who's next ---------------------------------------------------------------
upcoming_foe_data <- standings %>%
  filter(
      team == select_team_interest
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

##### Metrics - League --------------------------------------------------------

metrics <- football_calculate_competition_metrics(standings)

# table
metrics %>%
  mutate(Team = paste(crest,team)) %>%
  select(Team, Mood = metric_mood)  %>%
  mutate(
    Mood = as.character(Mood),
    Mood = case_when(
      str_detect(Mood,"Jubilant") ~ cell_spec(
        Mood, color = "black", background = "#98FB98"
      ),
      str_detect(Mood,"Optimistic") ~ cell_spec(
        Mood, color = "black", background = "#e5f5f9"
      ),
      str_detect(Mood,"Ambivalent") ~ cell_spec(
        Mood, color = "black", background = "#f7fcb9"
      ),
      str_detect(Mood,"Doldrums") ~ cell_spec(
        Mood, color = "black", background = "#ffc4c4"
      ),
      TRUE ~ Mood
    )
  ) %>%
  kbl(escape = F) %>%
  kable_classic("striped", full_width = TRUE)

##### Metrics - Team    --------------------------------------------------------

metrics_team <- metrics %>%
  filter(team == select_team_interest)

metrics_team_summary <- metrics_team %>% select(team,crest,metric_mood)

metrics_team %>%
  select(-c(metric_mood_numeric,metric_mood)) %>%
  pivot_longer(starts_with("metric"),
               names_to = "Variable",
               values_to = "Modifier"
               ) %>%
  mutate(
    Effect = case_when(
      str_detect(Modifier, "\\+") ~ "Positive",
      str_detect(Modifier, "\\-") ~ "Negative",
      TRUE ~ "Neutral"
    )
  ) %>%
  select(
    Effect,Modifier
  ) %>% arrange(Effect) %>%
  mutate(
    Effect = case_when(
      Effect == "Negative" ~ cell_spec(
        Effect, color = "white", bold = TRUE, background = "#F66E5CFF"
        ),
      Effect == "Positive" ~ cell_spec(
        Effect, color = "white", bold = TRUE, background = "#228B22"
      ),
      TRUE ~ Effect
    )
  ) %>%
  kbl(escape = F, caption = glue("Mood modifiers for {}.")) %>%
  kable_classic("striped", full_width = TRUE)


#####  Mapping ----------------------------------------------------------------

selected_league <- FootballData::football_odds %>%
  filter(league == select_league & country == select_country)

unique_teams <- unique(c(selected_league$team_home,selected_league$team_away))


#NOT CURRENTLY USED
get_historical_perfomance_OPENODDS <- function(
  team_interest = "Bristol City FC",
  team_foe = "Millwall FC",
  odds_data = FootballData::football_team_mappings,
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



