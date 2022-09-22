library(tidyverse)
library(lubridate)
library(fs)

source("001_2223_PGSFOGLIZZESE/U14F/scripts/999_functions.R")

pres <- readr::read_tsv("001_2223_PGSFOGLIZZESE/U14F/tmp/presenze.tsv")
players <- readr::read_table("001_2223_PGSFOGLIZZESE/U14F/tmp/players.tsv")

tail(pres, n = 12)

pres <- add(players,
    date = "20220920",
    assenti = c(0, 28, 14))

tail(as.data.frame(class), n = 24)

fs::file_copy("001_2223_PGSFOGLIZZESE/U14F/tmp/presenze.tsv",
          "001_2223_PGSFOGLIZZESE/U14F/tmp/presenze_old.tsv",
          overwrite = TRUE)
write_tsv(pres, "001_2223_PGSFOGLIZZESE/U14F/tmp/presenze.tsv")

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
    gt::gtsave("001_2223_PGSFOGLIZZESE/U14F/trainings/presenze.png", expand = 10)

# Presenze Totali
pres %>% 
    group_by(Numero, Cognome, Nome) %>% 
    summarise(Assenze = sum(assenti)) %>% 
    ungroup %>% 
    arrange(desc(Assenze), Cognome) %>% 
    gt::gt() %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("001_2223_PGSFOGLIZZESE/U14F/trainings/PresenzeTotale.png", expand = 10)

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
    gt::gtsave("001_2223_PGSFOGLIZZESE/U14F/trainings/PresenzeSettembre.png", expand = 10)
