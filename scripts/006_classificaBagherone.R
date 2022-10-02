library(tidyverse)
library(lubridate)
library(fs)

# Classifica
source("scripts/999_functions.R")

class <- readr::read_tsv("data/003_dati/classificaRaw.tsv")
players <- readr::read_table("data/003_dati/players.tsv")

tail(class, n = 12)

class <- classifica(players,
            date = "20220930", ### RICORDARSI DI CAMBIARE DATA ##
            vincitori = c(27, 54, 11, 5, 42))

tail(as.data.frame(class), n = 24)

fs::file_copy("data/003_dati/classificaRaw.tsv",
              "data/003_dati/classificaRaw_old.tsv",
              overwrite = TRUE)
write_tsv(class, "data/003_dati/classificaRaw.tsv")

#####################
# Punteggio
pres <- readr::read_tsv("data/003_dati/presenze.tsv")

class %>% 
    mutate(mese = month(date)) %>% 
    filter(mese == 9) %>% 
    left_join(pres) %>% 
    # group_by(mese) %>% 
    mutate(Punteggio = case_when(vincitori == 1 & assenti == 0 ~ 3,
                                 vincitori == 0 & assenti == 0 ~ 1,
                                 TRUE ~ 0)) %>% 
    group_by(Numero, Cognome, Nome, mese) %>% 
    summarise(Classifica = sum(Punteggio)) %>% 
    ungroup %>% 
    arrange(desc(Classifica), Cognome) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/003_dati/ClassificaSettembre.png", expand = 10)

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
    gt::gtsave("data/003_dati/ClassificaTotale.png", expand = 10)

