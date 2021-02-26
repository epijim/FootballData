FootballData
================

[![HitCount](http://hits.dwyl.com/epijim/FootballData.svg)](http://hits.dwyl.com/epijim/FootballData)


To rebuild run `make build`.

``` r
library(glue)
library(kableExtra)
library(tidyverse)
library(FootballData)

select_country <- "England"
select_league <- "Championship"
select_team_interest <- "Nottingham Forest FC"
```

## Competitions

Get all competitions.

``` r
competitions <- football_get_competition()

glimpse(competitions)
```

    ## Rows: 152
    ## Columns: 6
    ## $ league         <chr> "WC Qualification", "Primera B Nacional", "Superliga A…
    ## $ competition_id <int> 2006, 2023, 2024, 2149, 2025, 2147, 2008, 2026, 2020, …
    ## $ plan           <chr> "TIER_FOUR", "TIER_FOUR", "TIER_TWO", "TIER_FOUR", "TI…
    ## $ country        <chr> "Africa", "Argentina", "Argentina", "Argentina", "Arge…
    ## $ url_flag       <chr> NA, NA, NA, NA, NA, NA, NA, NA, "https://upload.wikime…
    ## $ flag           <glue> NA, NA, NA, NA, NA, NA, NA, NA, "<img src='https://up…

Filter to the ones on the free plan.

``` r
competitions_curated <- competitions %>%
  filter(
    plan == "TIER_ONE" 
  )
```

Show them.

``` r
competitions_curated %>%
  select(country,league,flag) %>%
  knitr::kable(escape = F) 
```

<table>

<thead>

<tr>

<th style="text-align:left;">

country

</th>

<th style="text-align:left;">

league

</th>

<th style="text-align:left;">

flag

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Brazil

</td>

<td style="text-align:left;">

Série A

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

England

</td>

<td style="text-align:left;">

Championship

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

England

</td>

<td style="text-align:left;">

Premier League

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Europe

</td>

<td style="text-align:left;">

UEFA Champions League

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

Europe

</td>

<td style="text-align:left;">

European Championship

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

France

</td>

<td style="text-align:left;">

Ligue 1

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/en/c/c3/Flag_of_France.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Germany

</td>

<td style="text-align:left;">

Bundesliga

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/commons/b/ba/Flag_of_Germany.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Italy

</td>

<td style="text-align:left;">

Serie A

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/en/0/03/Flag_of_Italy.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Netherlands

</td>

<td style="text-align:left;">

Eredivisie

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/commons/2/20/Flag_of_the_Netherlands.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Portugal

</td>

<td style="text-align:left;">

Primeira Liga

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Spain

</td>

<td style="text-align:left;">

Primera Division

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/en/9/9a/Flag_of_Spain.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

World

</td>

<td style="text-align:left;">

FIFA World Cup

</td>

<td style="text-align:left;">

NA

</td>

</tr>

</tbody>

</table>

## League info

Look at England - Championship.

``` r
league <- competitions_curated %>%
  filter(country == select_country & league == select_league) %>%
  pull(competition_id) %>%
  as.character() %>%
  football_get_teams()

league %>%
  select(team,crest) %>%
  knitr::kable(escape = F)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

team

</th>

<th style="text-align:left;">

crest

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Blackburn Rovers FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/59.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Norwich City FC

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/en/8/8c/Norwich_City.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Queens Park Rangers FC

</td>

<td style="text-align:left;">

<img src='http://upload.wikimedia.org/wikipedia/de/d/d4/Queens_Park_Rangers.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Stoke City FC

</td>

<td style="text-align:left;">

<img src='http://upload.wikimedia.org/wikipedia/de/a/a3/Stoke_City.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Swansea City AFC

</td>

<td style="text-align:left;">

<img src='http://upload.wikimedia.org/wikipedia/de/a/ab/Swansea_City_Logo.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Birmingham City FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/332.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Derby County FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/342.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Middlesbrough FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/343.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Sheffield Wednesday FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/345.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Watford FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/346.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Nottingham Forest FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/351.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Reading FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/355.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Barnsley FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/357.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Millwall FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/384.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Rotherham United FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/385.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Bristol City FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/387.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Luton Town FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/389.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Huddersfield Town AFC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/394.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Brentford FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/402.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Cardiff City FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/715.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

AFC Bournemouth

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1044.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Coventry City FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1076.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Preston North End FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1081.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:left;">

Wycombe Wanderers FC

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1146.svg' height='24'></img>

</td>

</tr>

</tbody>

</table>

## Standings

What’s the current league standings.

``` r
standings <- competitions_curated %>%
  filter(country == select_country & league == select_league) %>%
  pull(competition_id) %>%
  as.character() %>%
  football_get_standing()

glimpse(standings)
```

    ## Rows: 24
    ## Columns: 14
    ## $ position       <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,…
    ## $ playedGames    <int> 28, 27, 27, 27, 28, 28, 28, 27, 28, 28, 28, 27, 28, 27…
    ## $ form           <chr> "L,D,D,W,W", "W,W,W,D,W", "W,W,D,W,W", "D,W,D,W,W", "D…
    ## $ won            <int> 16, 15, 15, 14, 13, 12, 11, 11, 9, 12, 11, 10, 7, 9, 9…
    ## $ draw           <int> 7, 9, 8, 6, 9, 9, 7, 6, 12, 3, 3, 6, 14, 7, 7, 9, 6, 8…
    ## $ lost           <int> 5, 3, 4, 7, 6, 7, 10, 10, 7, 13, 14, 11, 7, 11, 11, 10…
    ## $ points         <int> 55, 54, 53, 48, 48, 45, 40, 39, 39, 39, 36, 36, 35, 34…
    ## $ goalsFor       <int> 35, 52, 35, 40, 31, 43, 31, 41, 32, 29, 32, 29, 26, 35…
    ## $ goalsAgainst   <int> 23, 27, 15, 29, 20, 28, 28, 29, 29, 33, 36, 34, 26, 31…
    ## $ goalDifference <int> 12, 25, 20, 11, 11, 15, 3, 12, 3, -4, -4, -5, 0, 4, -7…
    ## $ team_id        <int> 68, 402, 72, 355, 346, 1044, 343, 59, 70, 387, 1081, 3…
    ## $ team           <chr> "Norwich City FC", "Brentford FC", "Swansea City AFC",…
    ## $ url_team       <chr> "https://upload.wikimedia.org/wikipedia/en/8/8c/Norwic…
    ## $ crest          <glue> "<img src='https://upload.wikimedia.org/wikipedia/en/…

``` r
standings %>%
  select(position,points,team,form,crest) %>%
  knitr::kable(escape = F)
```

<table>

<thead>

<tr>

<th style="text-align:right;">

position

</th>

<th style="text-align:right;">

points

</th>

<th style="text-align:left;">

team

</th>

<th style="text-align:left;">

form

</th>

<th style="text-align:left;">

crest

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:left;">

Norwich City FC

</td>

<td style="text-align:left;">

L,D,D,W,W

</td>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/en/8/8c/Norwich_City.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

54

</td>

<td style="text-align:left;">

Brentford FC

</td>

<td style="text-align:left;">

W,W,W,D,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/402.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

53

</td>

<td style="text-align:left;">

Swansea City AFC

</td>

<td style="text-align:left;">

W,W,D,W,W

</td>

<td style="text-align:left;">

<img src='http://upload.wikimedia.org/wikipedia/de/a/ab/Swansea_City_Logo.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:left;">

Reading FC

</td>

<td style="text-align:left;">

D,W,D,W,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/355.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:left;">

Watford FC

</td>

<td style="text-align:left;">

D,L,D,W,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/346.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:left;">

AFC Bournemouth

</td>

<td style="text-align:left;">

W,L,L,L,L

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1044.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

40

</td>

<td style="text-align:left;">

Middlesbrough FC

</td>

<td style="text-align:left;">

L,D,L,L,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/343.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:left;">

Blackburn Rovers FC

</td>

<td style="text-align:left;">

L,W,W,D,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/59.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:left;">

Stoke City FC

</td>

<td style="text-align:left;">

D,D,L,D,D

</td>

<td style="text-align:left;">

<img src='http://upload.wikimedia.org/wikipedia/de/a/a3/Stoke_City.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:left;">

Bristol City FC

</td>

<td style="text-align:left;">

L,L,L,W,L

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/387.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:left;">

Preston North End FC

</td>

<td style="text-align:left;">

L,L,D,W,L

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1081.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:left;">

Barnsley FC

</td>

<td style="text-align:left;">

D,D,L,L,L

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/357.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:left;">

Millwall FC

</td>

<td style="text-align:left;">

W,D,D,D,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/384.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

14

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:left;">

Cardiff City FC

</td>

<td style="text-align:left;">

W,D,D,L,L

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/715.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:left;">

Luton Town FC

</td>

<td style="text-align:left;">

D,L,L,W,L

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/389.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

33

</td>

<td style="text-align:left;">

Queens Park Rangers FC

</td>

<td style="text-align:left;">

W,W,L,W,W

</td>

<td style="text-align:left;">

<img src='http://upload.wikimedia.org/wikipedia/de/d/d4/Queens_Park_Rangers.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

33

</td>

<td style="text-align:left;">

Huddersfield Town AFC

</td>

<td style="text-align:left;">

D,D,L,L,L

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/394.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

32

</td>

<td style="text-align:left;">

Nottingham Forest FC

</td>

<td style="text-align:left;">

W,W,D,L,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/351.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

31

</td>

<td style="text-align:left;">

Coventry City FC

</td>

<td style="text-align:left;">

D,L,D,W,L

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1076.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:left;">

Rotherham United FC

</td>

<td style="text-align:left;">

W,W,L,W,D

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/385.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:left;">

Derby County FC

</td>

<td style="text-align:left;">

L,W,W,W,L

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/342.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:left;">

Birmingham City FC

</td>

<td style="text-align:left;">

L,D,D,L,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/332.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:left;">

Sheffield Wednesday FC

</td>

<td style="text-align:left;">

L,W,W,L,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/345.svg' height='24'></img>

</td>

</tr>

<tr>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:left;">

Wycombe Wanderers FC

</td>

<td style="text-align:left;">

L,D,L,L,W

</td>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1146.svg' height='24'></img>

</td>

</tr>

</tbody>

</table>

## Scheduled games

``` r
upcoming_foe_data <- standings %>%
  filter(
      team == select_team_interest
    ) %>%
  pull(team_id) %>%
  as.character() %>%
  football_get_upcoming() %>%
  arrange(utcDate) 

glimpse(upcoming_foe_data)
```

    ## Rows: 18
    ## Columns: 14
    ## $ id          <int> 306708, 306723, 306732, 306745, 306756, 306765, 306785, 3…
    ## $ competition <df[,3]> <data.frame[18 x 3]>
    ## $ season      <df[,5]> <data.frame[18 x 5]>
    ## $ utcDate     <chr> "2021-02-13T12:30:00Z", "2021-02-17T19:00:00Z", "2021-02-…
    ## $ status      <chr> "SCHEDULED", "SCHEDULED", "SCHEDULED", "SCHEDULED", "SCHE…
    ## $ matchday    <int> 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 4…
    ## $ stage       <chr> "REGULAR_SEASON", "REGULAR_SEASON", "REGULAR_SEASON", "RE…
    ## $ group       <chr> "Regular Season", "Regular Season", "Regular Season", "Re…
    ## $ lastUpdated <chr> "2021-01-22T19:33:55Z", "2021-01-26T23:33:52Z", "2020-08-…
    ## $ odds        <df[,1]> <data.frame[18 x 1]>
    ## $ score       <df[,6]> <data.frame[18 x 6]>
    ## $ homeTeam    <df[,2]> <data.frame[18 x 2]>
    ## $ awayTeam    <df[,2]> <data.frame[18 x 2]>
    ## $ referees    <list> [[], [], [], [], [], [], [], [], [], [], [], [], [], [],…

## Metrics - League

``` r
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
  knitr::kable(escape = F)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

Team

</th>

<th style="text-align:left;">

Mood

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

<img src='https://upload.wikimedia.org/wikipedia/en/8/8c/Norwich_City.svg' height='24'></img>
Norwich City FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #98FB98 !important;">Jubilant:
Norwich City FC are on a roll</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/402.svg' height='24'></img>
Brentford FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #98FB98 !important;">Jubilant:
Brentford FC are on a roll</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='http://upload.wikimedia.org/wikipedia/de/a/ab/Swansea_City_Logo.svg' height='24'></img>
Swansea City AFC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #98FB98 !important;">Jubilant:
Swansea City AFC are on a roll</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/355.svg' height='24'></img>
Reading FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #e5f5f9 !important;">Optimistic:
Reading FC are doing well</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/346.svg' height='24'></img>
Watford FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #e5f5f9 !important;">Optimistic:
Watford FC are doing well</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1044.svg' height='24'></img>
AFC Bournemouth

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #e5f5f9 !important;">Optimistic:
AFC Bournemouth are doing well</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/343.svg' height='24'></img>
Middlesbrough FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #e5f5f9 !important;">Optimistic:
Middlesbrough FC are doing well</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/59.svg' height='24'></img>
Blackburn Rovers FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #e5f5f9 !important;">Optimistic:
Blackburn Rovers FC are doing well</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='http://upload.wikimedia.org/wikipedia/de/a/a3/Stoke_City.svg' height='24'></img>
Stoke City FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Stoke City FC aren’t doing well, but hey - at least they aren’t Wycombe
Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/387.svg' height='24'></img>
Bristol City FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Bristol City FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1081.svg' height='24'></img>
Preston North End FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Preston North End FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/357.svg' height='24'></img>
Barnsley FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Barnsley FC aren’t doing well, but hey - at least they aren’t Wycombe
Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/384.svg' height='24'></img>
Millwall FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Millwall FC aren’t doing well, but hey - at least they aren’t Wycombe
Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/715.svg' height='24'></img>
Cardiff City FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Cardiff City FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/389.svg' height='24'></img>
Luton Town FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Luton Town FC aren’t doing well, but hey - at least they aren’t Wycombe
Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='http://upload.wikimedia.org/wikipedia/de/d/d4/Queens_Park_Rangers.svg' height='24'></img>
Queens Park Rangers FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Queens Park Rangers FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/394.svg' height='24'></img>
Huddersfield Town AFC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Huddersfield Town AFC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/351.svg' height='24'></img>
Nottingham Forest FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Nottingham Forest FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1076.svg' height='24'></img>
Coventry City FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Coventry City FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/385.svg' height='24'></img>
Rotherham United FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Rotherham United FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/342.svg' height='24'></img>
Derby County FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Derby County FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/332.svg' height='24'></img>
Birmingham City FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Birmingham City FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/345.svg' height='24'></img>
Sheffield Wednesday FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #f7fcb9 !important;">Ambivalent:
Sheffield Wednesday FC aren’t doing well, but hey - at least they aren’t
Wycombe Wanderers FC</span>

</td>

</tr>

<tr>

<td style="text-align:left;">

<img src='https://crests.football-data.org/1146.svg' height='24'></img>
Wycombe Wanderers FC

</td>

<td style="text-align:left;">

<span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #ffc4c4 !important;">Doldrums:
Wycombe Wanderers FC are doing poorly. Avoid supporters at all
costs.</span>

</td>

</tr>

</tbody>

</table>

## Metrics - Team

``` r
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
  knitr::kable(escape = F)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

Effect

</th>

<th style="text-align:left;">

Modifier

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

<span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(246, 110, 92, 1) !important;">Negative</span>

</td>

<td style="text-align:left;">

  - so so season
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(246, 110, 92, 1) !important;">Negative</span>
    </td>
    <td style="text-align:left;">
      - conceded more than scored
        </td>
        </tr>
        <tr>
        <td style="text-align:left;">
        <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #228B22 !important;">Positive</span>
        </td>
        <td style="text-align:left;">
        \++ recent wins
        </td>
        </tr>
        </tbody>
        </table>
