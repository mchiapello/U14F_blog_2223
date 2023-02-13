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
opp <- "PVL"
us <- "BCV Foglizzo"
date <- "2023-02-12"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "11:00:00",
         season = "2022-2023",
         league = "U14F2",
         phase = "Andata",
         home_away = FALSE,
         day_number = 1,
         match_number = 2263,
         set_won = c(1, 3),
         home_away_team  = c("*", "a"),
         won_match = c(FALSE, TRUE),
         coach = c("Chiapello", "Vottero"),
         assistent = c("Bernardi", ""))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
