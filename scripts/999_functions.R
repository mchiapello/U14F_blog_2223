# create setup data
ma <- function(date = "2022-09-01",
               opp = "altri",
               type = c("allenamento", "partita"),
               time = "19:30:00",
               season = "2022-2023",
               league = "U14F",
               phase = "andata",
               home_away = FALSE,
               day_number = 2,
               match_number = NA,
               text_encodong = 1,
               regulation = "indoor rally point",
               zones_or_cones = "Z",
               team_id = c("FOG", str_to_upper(str_sub(opp, start = 1L, end = 3L))),
               team = c(us, opp),
               set_won = c(3, 2),
               coach = c("Chiapello", "Unknow"),
               assistent = c("Bernardi", "Unknow"),
               shirt_colour = c("White", "Blue"),
               X7 = NA,
               home_away_team  = c("*", "a"),
               won_match = c(TRUE, FALSE)){
    type <- match.arg(type)
    output <- vector(mode = "list", length = 3L)
    if(type == "partita"){
        # OUTPATH
        mat <- paste0(here(), 
                      "/data/002_Partite/", 
                      date, "_", opp)
        dir_create(mat) 
        output[[1]] <- mat
        
        # MATCH
        output[[2]] <- tibble(date = lubridate::ymd(date),
                              time = lubridate::hms(time),
                              season = season,
                              league = league,
                              phase = phase,
                              home_away = home_away,
                              day_number = day_number,
                              match_number = match_number,
                              text_encodong = text_encodong,
                              regulation = regulation,
                              zones_or_cones = zones_or_cones)
        # TEAM
        output[[3]] <- tibble(team_id = team_id,
                              team = team,
                              set_won = set_won,
                              coach = coach,
                              assistent = assistent,
                              shirt_colour = shirt_colour,
                              X7 = X7,
                              home_away_team  = home_away_team,
                              won_match = won_match)
        return(output)
    } else {
        # OUTPATH
        mat <- paste0(here(), 
                      "/data/000_allenamenti/", 
                      date)
        dir_create(mat) 
        output[[1]] <- mat
        # MATCH
        output[[2]] <- tibble(date = lubridate::ymd(date),
                              time = lubridate::hms(time),
                              season = season,
                              league = league,
                              phase = phase,
                              home_away = home_away,
                              day_number = day_number,
                              match_number = match_number,
                              text_encodong = text_encodong,
                              regulation = regulation,
                              zones_or_cones = zones_or_cones)
        # TEAM
        output[[3]] <- tibble(team_id = team_id,
                              team = team,
                              set_won = set_won,
                              coach = coach,
                              assistent = assistent,
                              shirt_colour = shirt_colour,
                              X7 = X7,
                              home_away_team  = home_away_team,
                              won_match = won_match)
        return(output)
    }
}

##########################
# Presenze
add <- function(x,
                date = "20220830",
                assenti = c(22, 5)){
    pres %>% 
        bind_rows(x %>% 
                      mutate(date = lubridate::ymd(date),
                             assenti = ifelse(Numero %in% assenti, 1, 0)))
}

##########################
# Classifica
classifica <- function(x,
                date = "20220830",
                vincitori = c(22, 5)){
    class %>% 
        bind_rows(x %>% 
                      mutate(date = lubridate::ymd(date),
                             vincitori = ifelse(Numero %in% vincitori, 1, 0)))
}

##########################
# Elenco Atleti
prelat <- function(path, pathout = out, team = "avversari"){
    x <- read_lines(path)
    i <- 1
    out2 <- tibble(Numero = NA, Cognome = NA, Nome = NA)
    while (i < length(x)){
        out2 <- out2 |> 
            bind_rows(tibble(Numero = x[i],
                             Cognome = word(x[i+1]),
                             Nome = word(x[i+1], start = 2)))
        i <- i + 2
    }
    out2 <- out2 |> 
        drop_na()
    write_tsv(out2, file = paste0(pathout, "/", team, ".tsv"))
}

elat <- function(path, team = "BCV Foglizzo", out = "data/002_Partite/"){
    x <- read_tsv(path, show_col_types = FALSE)
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
           name = paste0(x$Nome, " ", x$Cognome)) |> 
        saveRDS(paste0(out, "/", team, ".RDS"))
    
}
