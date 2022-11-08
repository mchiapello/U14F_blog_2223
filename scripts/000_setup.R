# Needed libraries
library(datavolley)
library(ovscout2)
library(tidyverse)
library(fs)
library(here)
setwd(here())
source("scripts/999_functions.R")

###############################################################################
# Create match/allenamento
opp <- "Samone"
us <- "PGS Foglizzese"
date <- "2022-11-08"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "18:15:00",
         season = "2022-2023",
         league = "Allenamento",
         phase = "Amichevole",
         home_away = FALSE,
         day_number = 15,
         match_number = 321,
         set_won = c(4, 1),
         home_away_team  = c("a", "*"),
         won_match = c(FALSE, TRUE))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
