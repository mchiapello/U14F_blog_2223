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
               assistent = c("Berardi", "Unknow"),
               shirt_colour = c("White", "Blue"),
               X7 = NA,
               home_away_team  = c("*", "a"),
               won_match = c(TRUE, FALSE)){
    type <- match.arg(type)
    output <- vector(mode = "list", length = 3L)
    if(type == "partita"){
        # OUTPATH
        mat <- paste0(here(), 
                      "/001_2223_PGSFoglizzese/U14F/scouts/partite/", 
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
                      "/001_2223_PGSFoglizzese/U14F/scouts/allenamenti/", 
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
