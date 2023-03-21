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
opp <- "ValChisone"
us <- "BCV Foglizzo"
date <- "2023-03-18"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "15:30:00",
         season = "2022-2023",
         league = "U14F2",
         phase = "Andata",
         home_away = TRUE,
         day_number = 5,
         match_number = 2279,
         set_won = c(1, 3),
         home_away_team  = c("a", "*"),
         won_match = c(FALSE, TRUE),
         coach = c("Chiapello", "Pignatelli"),
         assistent = c("", ""))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
