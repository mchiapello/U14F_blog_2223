
#### FILE DA MODIFICARE


library(tidyverse)
library(rvest)
library(gt)
library(gtExtras)

films <- content %>% html_elements(".gara-big-wrap , h3, .h3-wrap") %>% 
    html_text2()

df <- tibble(a = films) %>% 
    filter(!grepl("Under|ATTENZIONE", a)) %>% 
    separate(a, into = c("data", "a"), sep = "\n", extra = "merge") %>% 
    separate(a, into = c("gara", "a"), sep = "\n", extra = "merge") %>% 
    separate(a, into = c("Indirizzo", "a"), sep = "\n", extra = "merge") %>% 
    separate(a, into = c("Città", "a"), sep = "\n", extra = "merge") %>% 
    separate(a, into = c("data2", "a"), sep = "\n", extra = "merge") %>% 
    separate(a, into = c("gara2", "a"), sep = "\n", extra = "merge") %>% 
    separate(a, into = c("Home Team", "a"), sep = "\n", extra = "merge") %>% 
    separate(a, into = c("Away Team", "a"), sep = "\n", extra = "drop") %>% 
    select(data, "Home Team", "Away Team", Città, Indirizzo)

# Nostre partite
df %>% 
    filter(`Home Team` == "Basso Canavese Foglizzo" | `Away Team` == "Basso Canavese Foglizzo") %>% 
    gt() %>% 
    gt::tab_header(title = gt::md("**Calendario**")) %>% 
    gtExtras::gt_theme_538()  %>% 
    gt::gtsave("data/002_Partite/Calendario.png", expand = 10)

# Creare eventi per google calendar
df %>% 
    filter(`Home Team` == "Basso Canavese Foglizzo" | `Away Team` == "Basso Canavese Foglizzo") %>% 
    mutate(data = str_remove(data, "Sab ")) %>% 
    separate(data, into = c("Start Date", "Start Time"), sep = " ") %>% 
    mutate("Subject" = "Partita U14F",
           `Start Time` = `Start Time`,
           "End Date" = `Start Date`,
           "Description" = paste0(`Home Team`, " - ", `Away Team`),
           "Location" = paste0(Indirizzo, ", ", Città),
           `Start Time` = str_replace(`Start Time`, "\\.", ":"),
           `End Time` = paste0(as.numeric(str_sub(`Start Time`, start = 1L, end = 2L)) + 2,
                               ":", str_sub(`Start Time`, start = 3L, end = 5L))) %>% 
    select(Subject, `Start Date`, `End Date`, `Start Time`, `End Time`, 
           Description, Location) %>% 
    write_csv("data/002_Partite/calendarioNOSTRO.csv")
