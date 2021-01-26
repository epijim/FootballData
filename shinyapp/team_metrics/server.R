library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {

    ## Update league choices based on country
    observe({
        x <- input$country

        leagues <- competitions %>%
            filter(country == x) %>%
            pull(league)

        # Can use character(0) to remove all choices
        if (is.null(leagues))
            leagues <- character(0)

        # Can also set the label and select items
        updateSelectInput(session, "league",
                          choices = leagues,
                          selected = head(leagues, 1)
        )
    })

    ## Get standing of selected league when button pressed
    team_standing <- eventReactive(input$get_league, {
        competitions %>%
            filter(country == input$country & league == input$league) %>%
            pull(competition_id) %>%
            as.character() %>%
            football_get_standing(api_token = readLines("api_key"))
    })

    ## Update team choices based on country
    observe({
        x <- team_standing()

        teams <- x %>%
            pull(team) %>%
            unique()

        # Can use character(0) to remove all choices
        if (is.null(teams))
            teams <- character(0)

        # Can also set the label and select items
        updateSelectInput(session, "team",
                          choices = teams,
                          selected = head(teams, 1)
        )
    })

    ## Update team choices based on league
    observe({
        x <- input$country

        leagues <- competitions %>%
            filter(country == x) %>%
            pull(league)

        # Can use character(0) to remove all choices
        if (is.null(leagues))
            leagues <- character(0)

        # Can also set the label and select items
        updateSelectInput(session, "league",
                          choices = leagues,
                          selected = tail(leagues, 1)
        )
    })

    ### Interim data ---------------------------------------------

    standings <- reactive({
        team_standing() %>% football_calculate_competition_metrics()
    })

    upcoming_foe <- reactive({
        team_standing() %>%
            filter(
                team == input$team
            ) %>%
            pull(team_id) %>%
            as.character() %>%
            football_get_upcoming(api_token = readLines("api_key")) %>%
            arrange(utcDate) %>%
            slice(1)
    })

    ### Outputs ---------------------------------------------


    output$tab_metrics <- renderText({
        req(input$team)

        x <- standings()

        x %>%
            mutate(Team = paste(crest,team)) %>%
            select(Team,Points = points, Mood = metric_mood)  %>%
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


    })

    output$team_info <- renderText({
        req(input$team)

        x <- standings()

        metrics_team <- x %>%
            filter(team == input$team)

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
            kbl(escape = F, caption = glue("Mood modifiers for {input$team}.")) %>%
            kable_classic("striped", full_width = TRUE)
    })

    output$team_deets <- renderText({
        req(input$team)

        validate(
          need(!is.null(standings()), "Waiting on league data.")
        )

        metrics_team <- standings() %>%
            filter(team == input$team)

        team_standing <- team_standing() %>%
            filter(team == input$team)

        next_game <- upcoming_foe()

        upcoming_foe_date <- as.Date(next_game$utcDate)

        upcoming_foe_team <- paste0(setdiff(
            c(next_game$awayTeam$name,next_game$homeTeam$name),input$team
        ), collapse = "")

        glue(
            "{metrics_team$crest} <b>{metrics_team$team}</b></br>",
            "Won {team_standing$won}, Drew {team_standing$draw}, Lost {team_standing$lost}</br>",
            "Recent form: {team_standing$form}</br>",
            "Next game on {upcoming_foe_date} against {upcoming_foe_team}"
        )


    })

})
