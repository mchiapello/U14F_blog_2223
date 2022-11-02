library(tidyverse)
library(lubridate)
library(fs)

source("scripts/999_functions.R")

pres <- readr::read_tsv("data/003_dati/presenze.tsv")
players <- readr::read_table("data/003_dati/players.tsv")

tail(pres, n = 14)

pres <- add(players,
    date = "20221101", ### RICORDARSI DI CAMBIARE DATA ##
    assenti = c(0,46,40,34))

tail(as.data.frame(pres), n = 24)

fs::file_copy("data/003_dati/presenze.tsv",
              "data/003_dati/presenze_old.tsv",
              overwrite = TRUE)
write_tsv(pres, "data/003_dati/presenze.tsv")

# Presenze raw
pres %>% 
    mutate(date = format(date, "%d-%m")) %>% 
    select(-Numero) %>% 
    pivot_wider(names_from = date,
                values_from = assenti) %>% 
    janitor::adorn_totals("row") %>% 
    janitor::adorn_totals("col") %>% 
    arrange((Total)) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/000_allenamenti/presenze.png", expand = 10)

# Presenze Totali
pres %>% 
    group_by(Cognome, Nome) %>% 
    summarise(Assenze = sum(assenti)) %>% 
    ungroup %>% 
    arrange(desc(Assenze), Cognome) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/000_allenamenti/PresenzeTotale.png", expand = 10)

# Presenze mensili
pres %>% 
    mutate(mese = month(date)) %>% 
    filter(mese == 11) %>% 
    group_by(Cognome, Nome) %>% 
    summarise(Assenze = sum(assenti)) %>% 
    ungroup %>% 
    arrange(desc(Assenze), Cognome) %>% 
    gt::gt() %>% 
    gt::tab_header(title = gt::md("**Novembre**")) %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/000_allenamenti/PresenzeNovembre1.png", expand = 10)

pres %>% 
    mutate(mese = month(date)) %>% 
    filter(mese == 11) %>%
    mutate(date = format(date, "%d-%m")) %>%
    select(-Numero) %>% 
    pivot_wider(names_from = date,
                values_from = assenti) %>% 
    select(-mese) %>% 
    janitor::adorn_totals("row") %>% 
    janitor::adorn_totals("col") %>% 
    arrange((Total)) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538() %>% 
    gt::gtsave("data/000_allenamenti/PresenzeNovembre2.png", expand = 10)



