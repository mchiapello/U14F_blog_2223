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
opp <- "Alto Canavese"
us <- "BCV Foglizzo"
date <- "2023-02-25"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "15:30:00",
         season = "2022-2023",
         league = "U14F2",
         phase = "Andata",
         home_away = FALSE,
         day_number = 3,
         match_number = 2269,
         set_won = c(3, 0),
         home_away_team  = c("*", "a"),
         won_match = c(TRUE, FALSE),
         coach = c("Chiapello", "Mantovani"),
         assistent = c("Bernardi", ""))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
