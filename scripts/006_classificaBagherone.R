library(tidyverse)
library(lubridate)
library(fs)

# Classifica
source("scripts/999_functions.R")

class <- readr::read_tsv("data/003_dati/classificaRaw.tsv")
players <- readr::read_table("data/003_dati/players.tsv")

tail(class, n = 12)

class <- classifica(players,
            date = "20221021", ### RICORDARSI DI CAMBIARE DATA ##
            vincitori = c(40,34,31,9,30))

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
    select(-Numero) %>% 
    filter(mese == 10) %>% 
    left_join(pres %>% select(-Numero)) %>% 
    # group_by(mese) %>% 
    mutate(Punteggio = case_when(vincitori == 1 & assenti == 0 ~ 3,
                                 vincitori == 0 & assenti == 0 ~ 1,
                                 TRUE ~ 0)) %>% 
    group_by(Cognome, Nome, mese) %>% 
    summarise(Classifica = sum(Punteggio)) %>% 
    ungroup %>% 
    arrange(desc(Classifica), Cognome) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/003_dati/ClassificaOttobre.png", expand = 10)

class %>% 
    select(-Numero) %>% 
    left_join(pres %>% select(-Numero)) %>% 
    mutate(Punteggio = case_when(vincitori == 1 & assenti == 0 ~ 3,
                                 vincitori == 0 & assenti == 0 ~ 1,
                                 TRUE ~ 0)) %>% 
    group_by(Cognome, Nome) %>% 
    summarise(Classifica = sum(Punteggio)) %>% 
    ungroup %>% 
    arrange(desc(Classifica), Cognome) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/003_dati/ClassificaTotale.png", expand = 10)

