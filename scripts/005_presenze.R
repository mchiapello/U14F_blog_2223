library(tidyverse)
library(lubridate)
library(fs)

source("scripts/999_functions.R")

pres <- readr::read_tsv("data/003_dati/presenze.tsv")
players <- readr::read_table("data/003_dati/players.tsv")

tail(pres, n = 12)

pres <- add(players,
    date = "20220922",
    assenti = c(0, 14))

tail(as.data.frame(class), n = 24)

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
    gt::gtsave("data/003_dati/presenze.png", expand = 10)

# Presenze Totali
pres %>% 
    group_by(Numero, Cognome, Nome) %>% 
    summarise(Assenze = sum(assenti)) %>% 
    ungroup %>% 
    arrange(desc(Assenze), Cognome) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/003_dati/PresenzeTotale.png", expand = 10)

# Presenze mensili
pres %>% 
    mutate(mese = month(date)) %>% 
    filter(mese == 9) %>% 
    group_by(Numero, Cognome, Nome) %>% 
    summarise(Assenze = sum(assenti)) %>% 
    ungroup %>% 
    arrange(desc(Assenze), Cognome) %>% 
    gt::gt() %>% 
    gt::tab_header(title = gt::md("**Settembre**")) %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/003_dati/PresenzeSettembre.png", expand = 10)
