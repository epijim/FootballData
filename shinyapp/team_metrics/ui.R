

dashboardPage(

    dashboardHeader(title = 'Football mood predictor'),

    ## Side bar ----
    dashboardSidebar(
        sidebarMenu(
            id = "tabs",
            menuItem("League selection",
                     tabName = 'herald',
                     icon = icon("broom"),
                     startExpanded = TRUE,
                     selectInput("country",
                                 label = "Select country:",
                                 multiple = FALSE,
                                 selected = "England",
                                 choices = unique(competitions$country)
                                 ),
                     selectInput("league",
                                 label = "Select league:",
                                 multiple = FALSE,
                                 choices = "Loading",
                                 selected = "Loading"
                     ),
                     actionButton("get_league",
                                  label = "Get league data",
                                  icon = icon("cloud-download-alt")
                                  ),
                     br()
            ),
            menuItem("Team selection",
                     tabName = 'herald',
                     icon = icon("broom"),
                     startExpanded = TRUE,
                     selectInput("team",
                                 label = "Select team:",
                                 multiple = FALSE,
                                 choices = "Get league data first",
                                 selected = "Get league data first"
                     )
            )
        )

    ),

    ## Body ------
    dashboardBody(
      # shinyDashboardThemes(
      #   theme = "blue_gradient"
      # ),
      fluidRow(
        column(width = 8,
            box(
               title = "League metrics", status = "primary",
               solidHeader = TRUE,
               collapsible = TRUE,
               width = NULL,
               htmlOutput("tab_metrics")
               )
        ),
      column(width = 4,
        box(
          title = "Team metrics", status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width = NULL,
          htmlOutput("team_info")
        ),
        box(
          title = "Team metrics", status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width = NULL,
          htmlOutput("team_deets")
        )
      )
      )
    )


)

# # Define UI for application that draws a histogram
# shinyUI(fluidPage(
#
#     # Application title
#     titlePanel("Old Faithful Geyser Data"),
#
#     # Sidebar with a slider input for number of bins
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("bins",
#                         "Number of bins:",
#                         min = 1,
#                         max = 50,
#                         value = 30)
#         ),
#
#         # Show a plot of the generated distribution
#         mainPanel(
#             plotOutput("distPlot")
#         )
#     )
# ))
