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
opp <- "Calton"
us <- "PGS Foglizzese"
date <- "2023-01-03"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "18:45:00",
         season = "2022-2023",
         league = "amichevole",
         phase = "",
         home_away = FALSE,
         day_number = 1,
         match_number = NA,
         set_won = c(0, 5),
         home_away_team  = c("a", "*"),
         won_match = c(FALSE, TRUE),
         coach = c("Chiapello", "Peroglio"),
         assistent = c("Bernardi", "Waller"))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
