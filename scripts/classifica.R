library(tidyverse)
library(lubridate)
library(fs)

# Classifica
source("001_2223_PGSFOGLIZZESE/U14F/scripts/999_functions.R")

class <- readr::read_tsv("001_2223_PGSFOGLIZZESE/U14F/tmp/classificaRaw.tsv")
players <- readr::read_table("001_2223_PGSFOGLIZZESE/U14F/tmp/players.tsv")

tail(class, n = 12)

class <- classifica(players,
            date = "20220920",
            vincitori = c(22,11,27))

tail(as.data.frame(class), n = 24)

fs::file_copy("001_2223_PGSFOGLIZZESE/U14F/tmp/classificaRaw.tsv",
          "001_2223_PGSFOGLIZZESE/U14F/tmp/classificaRaw_old.tsv",
          overwrite = TRUE)
write_tsv(class, "001_2223_PGSFOGLIZZESE/U14F/tmp/classificaRaw.tsv")

#####################
# Punteggio
pres <- readr::read_tsv("001_2223_PGSFOGLIZZESE/U14F/tmp/presenze.tsv")

class %>% 
    left_join(pres) %>% 
    group_by(date) %>% 
    mutate(Punteggio = case_when(vincitori == 1 & assenti == 0 ~ 3,
                                 vincitori == 0 & assenti == 0 ~ 1,
                                 TRUE ~ 0)) %>% 
    arrange(date, desc(Punteggio), Cognome) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("001_2223_PGSFOGLIZZESE/U14F/trainings/ClassificaParziale.png", expand = 10)

class %>% 
    left_join(pres) %>% 
    mutate(Punteggio = case_when(vincitori == 1 & assenti == 0 ~ 3,
                                 vincitori == 0 & assenti == 0 ~ 1,
                                 TRUE ~ 0)) %>% 
    group_by(Numero, Cognome, Nome) %>% 
    summarise(Classifica = sum(Punteggio)) %>% 
    ungroup %>% 
    arrange(desc(Classifica), Cognome) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("001_2223_PGSFOGLIZZESE/U14F/trainings/ClassificaTotale.png", expand = 10)
