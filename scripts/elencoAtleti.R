elat <- function(x, team = "BCV Foglizzo"){
    x <- read_tsv("data/003_dati/players.tsv")
    tibble(X1 = 0,
           number = x$Numero,
           X3 = 1:nrow(x),
           starting_position_set1 = NA,
           starting_position_set2 = NA,
           starting_position_set3 = NA,
           starting_position_set4 = NA,
           starting_position_set5 = NA,
           player_id = paste0(str_sub(x$Cognome, start = 1L, end = 3L), "-",
                              str_sub(x$Nome, start = 1L, end = 3L)),
           lastname = x$Cognome,
           firstname = x$Nome,
           nickname = "",
           special_role = "",
           role = x$Ruolo,
           foreign = FALSE,
           X16 = player_id,
           X17 = NA,
           X18 = NA,
           name = paste0(x$Nome, " ", x$Cognome))
    
}