library(shiny)
library(tidyverse)
library(glue)
library(shinydashboard)
library(dashboardthemes)
library(kableExtra)
library(FootballData)

# Get competitions
competitions <- football_get_competition(api_token = readLines("api_key")) %>%
  filter(plan == "TIER_ONE" &
           !country %in% c("World","Europe"))
