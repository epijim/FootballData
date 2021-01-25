## Mappings

football_team_mappings <- tibble::tribble(
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

usethis::use_data(football_team_mappings, overwrite = TRUE)
