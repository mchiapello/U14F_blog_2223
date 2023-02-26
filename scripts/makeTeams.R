library(tidyverse)

makeTeams <- function(x, nteams = 3, assenti = c("Ciravolo", "Pascarella", "Pau")){
    tmp <- x |> 
        filter(!Cognome %in% assenti) 
    tmp |> 
        sample_n(nrow(tmp)) |> 
        mutate(Squadra = rep(1:nteams, 10)[1:nrow(tmp)]) |> 
        arrange(Squadra)
}


x <- readr::read_table(paste0(here::here(), "/data/003_dati/players.tsv"), show_col_types = FALSE)
makeTeams(x, nteams = 2, assenti = c("Pascarella", "Ciravolo", "Pau"))
