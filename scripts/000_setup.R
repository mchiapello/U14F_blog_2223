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
opp <- "Parella"
us <- "PGS Foglizzese"
date <- "2022-11-19"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "15:30:00",
         season = "2022-2023",
         league = "U14F - Girone E",
         phase = "Ritorno",
         home_away = FALSE,
         day_number = 15,
         match_number = 336,
         set_won = c(3, 0),
         home_away_team  = c("*", "a"),
         won_match = c(TRUE, FALSE))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
