d <- dir_ls("data/002_Partite/all/", regexp = "dvw")
lx <- list()
## read each file
for (fi in seq_along(d)) lx[[fi]] <- dv_read(d[fi], insert_technical_timeouts = FALSE)
## now extract the play-by-play component from each and bind them together
px <- list()
for (fi in seq_along(lx)) px[[fi]] <- plays(lx[[fi]])
px <- do.call(rbind, px)

px %>% 
    count(match_id)

team_select = noi
pp <- px %>% 
        left_join(px %>% 
                      mutate(time = str_sub(as.character(time), start = 1L, end = 10L)) %>% 
                      count(match_id, team, time) %>% 
                      filter(team != "PGS Foglizzese") %>% 
                      select(match_id, SQ = team, DT= time)) %>% 
        group_by(SQ, DT) %>%
        dplyr::summarize(SerT = sum(skill == "Serve" & team %in% team_select, na.rm = TRUE),
                         SerP = sum(evaluation_code == "#" & skill == "Serve" & team %in% team_select, na.rm = TRUE),
                         SerE = sum(evaluation_code == "=" & skill == "Serve" & team %in% team_select, na.rm = TRUE),
                         AtkT = sum(skill == "Attack" & team %in% team_select, na.rm = TRUE),
                         AtkP = sum(evaluation_code == "#" & skill == "Attack" & team %in% team_select, na.rm = TRUE),
                         AtkE = sum(evaluation_code == "=" & skill == "Attack" & team %in% team_select, na.rm = TRUE),
                         BloT = sum(skill == "Block" & team %in% team_select, na.rm = TRUE),
                         BloP = sum(evaluation_code == "#" & skill == "Block" & team %in% team_select, na.rm = TRUE),
                         BloE = sum(evaluation_code == "#" & skill == "Block" & team %in% team_select, na.rm = TRUE),
                         Tentativi = sum(SerT, AtkT, BloT),
                         Punti = sum(SerP, AtkP, BloP),
                         Errori = sum(SerE, AtkE, BloE)) %>% 
    ungroup()

pp %>% 
    mutate(`SerP%` = round(SerP/SerT*100, 0),
           `SerE%` = round(SerE/SerT*100, 0),
           `AtkP%` = round(AtkP/AtkT*100, 0),
           `AtkE%` = round(AtkE/AtkT*100, 0)) %>% 
    select(SQ, DT,
           `SerP%`, `SerE%`,
           `AtkP%`, `AtkE%`) %>% 
    gt::gt()

    