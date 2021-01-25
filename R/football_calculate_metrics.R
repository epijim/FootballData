#' Take API data and calculate some metrics for fun
#'
#' Turn data into some fun 'how would a supporter be feeling' metrics.
#'
#' @param competition_standings Data frame from \code{football_get_standing}
#'
#' @return For a particular competition - metrics on all teams.
#'
#'
#' @export

football_calculate_competition_metrics <- function(
  competition_standings
){
  n_rows <- nrow(competition_standings)

  competition_standings %>%
    arrange(position) %>%
    mutate(
      metric_season_position = case_when(
        position == min(position) ~ "++++ top of the league",
        position >= max(position) - 1 ~ "---- relagation?",
        position / max(position) < 0.2 ~ "++ strong league position",
        position / max(position) < 0.5 ~ "+ safe in middle of league",
        position / max(position) < 0.8 ~ "- so so season",
        position / max(position) < 1.1 ~ "-- poor season",
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
      )
    ) %>% rowwise() %>%
    mutate(concat = paste0(c_across(starts_with("metric_")), collapse = "")) %>%
    mutate(
      plus = str_count(concat,"\\+"),
      neg = str_count(concat,"\\-"),
      metric_mood_numeric = plus - neg,
      metric_mood = case_when(
        metric_mood_numeric > 5 ~ glue("Jubilant: {team} are on a roll"),
        metric_mood_numeric > 0 ~ glue("Optimistic: {team} are doing well"),
        position == n_rows ~ glue("Doldrums: {team} are doing poorly. Avoid supporters at all costs."),
        metric_mood_numeric > -5 ~
          glue("Ambivalent: {team} aren't doing well, but hey - at least they aren't {competition_standings %>% slice(n()) %>% pull(team)}"),
        TRUE ~ glue("Doldrums: {team} are doing poor. Now's a good time to bad mouth the manager.")
      )
    ) %>%
    select(
      team,crest,points,starts_with("metric")
    )
}
