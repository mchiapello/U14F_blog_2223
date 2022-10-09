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
opp <- "Allenamento"
us <- "PGS Foglizzese"
date <- "2022-10-07"

pp <- ma(date = date, 
         opp = opp,
         type = "allenamento",
         time = "19:00:00",
         season = "2022-2023",
         league = "U14F",
         phase = "pre",
         home_away = FALSE,
         day_number = 14,
         match_number = NA,
         set_won = c(2, 0),,
         home_away_team  = c("a", "*"),
         won_match = c(TRUE, FALSE))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
