library(tidyverse)
library(lubridate)
library(fs)

source("scripts/999_functions.R")

pres <- readr::read_tsv("data/003_dati/presenze.tsv")
players <- readr::read_table("data/003_dati/players.tsv")

tail(pres, n = 12)

pres <- add(players,
    date = "20221005", ### RICORDARSI DI CAMBIARE DATA ##
    assenti = c())

tail(as.data.frame(pres), n = 24)

fs::file_copy("data/003_dati/presenze.tsv",
              "data/003_dati/presenze_old.tsv",
              overwrite = TRUE)
write_tsv(pres, "data/003_dati/presenze.tsv")

# Presenze raw
pres %>% 
    mutate(date = format(date, "%d-%m")) %>% 
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
    group_by(Numero, Cognome, Nome) %>% 
    summarise(Assenze = sum(assenti)) %>% 
    ungroup %>% 
    arrange(desc(Assenze), Cognome) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/000_allenamenti/PresenzeTotale.png", expand = 10)

# Presenze mensili
pres %>% 
    mutate(mese = month(date)) %>% 
    filter(mese == 10) %>% 
    group_by(Numero, Cognome, Nome) %>% 
    summarise(Assenze = sum(assenti)) %>% 
    ungroup %>% 
    arrange(desc(Assenze), Cognome) %>% 
    gt::gt() %>% 
    gt::tab_header(title = gt::md("**Ottobre**")) %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/000_allenamenti/PresenzeOttobre1.png", expand = 10)

pres %>% 
    mutate(mese = month(date)) %>% 
    filter(mese == 10) %>%
    mutate(date = format(date, "%d-%m")) %>% 
    pivot_wider(names_from = date,
                values_from = assenti) %>% 
    select(-Numero, -mese) %>% 
    janitor::adorn_totals("row") %>% 
    janitor::adorn_totals("col") %>% 
    arrange((Total)) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538() %>% 
    gt::gtsave("data/000_allenamenti/PresenzeOttobre2.png", expand = 10)



