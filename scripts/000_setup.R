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
opp <- "To.volley"
us <- "BCV Foglizzo"
date <- "2023-03-05"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "10:30:00",
         season = "2022-2023",
         league = "U14F2",
         phase = "Andata",
         home_away = TRUE,
         day_number = 4,
         match_number = 2273,
         set_won = c(3, 0),
         home_away_team  = c("a", "*"),
         won_match = c(TRUE, FALSE),
         coach = c("Chiapello", "Callegher"),
         assistent = c("Bernardi", "Mura"))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
