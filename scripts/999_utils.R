`%eq%` <- function (x, y) x == y & !is.na(x) & !is.na(y)

single_value_or_na <- function(x) if (length(x) == 1) x else NA
single_value_or_na_char <- function(x) if (length(x) == 1) x else NA_character_
single_value_or_na_int <- function(x) if (length(x) == 1) x else NA_integer_


## guess data type given plays data.frame
guess_data_type <- function(x) {
    if (!"home_player_id3" %in% names(x)) {
        if ("eventgrade" %in% names(x)) "perana_beach" else "beach"
    } else {
        if ("eventgrade" %in% names(x)) "perana_indoor" else "indoor"
    }
}

to_char_noNA <- function(z) {
    out <- as.character(z)
    out[is.na(out) | out %in% "NA"] <- ""
    out
}

cat0 <- function(...) cat(..., sep = "")

##################
# Functions
# Points
vr_points <- function(x, by = "player", team_select = noi) {
    as_for_datavolley <- TRUE
    by <- match.arg(tolower(by), c("player", "set"))
    if (by == "player") {
        vr_pts <- plays(x) %>% 
            dplyr::filter(.data$team %in% team_select, .data$player_id != "unknown player") %>% 
            group_by(.data$player_id) %>%
            dplyr::summarize(Tot = sum(.data$evaluation_code == "#" & .data$skill %in% c("Serve", "Attack", "Block")),
                             # BP = sum(.data$evaluation_code == "#" & .data$skill %in% c("Serve", "Attack", "Block") & .data$serving_team == team_select),
                             Nerr = sum((.data$evaluation %eq% "Error" & .data$skill %in% c("Serve", "Reception", "Attack", if (!as_for_datavolley) "Set", if (!as_for_datavolley) "Freeball")) | (!as_for_datavolley & .data$evaluation %eq% "Invasion" & .data$skill %eq% "Block") | (.data$evaluation %eq% "Blocked" & .data$skill %eq% "Attack")),
                             'W-L' = .data$Tot - .data$Nerr)
        vr_pts <- vr_pts %>%
            bind_rows(
                plays(x) %>% dplyr::filter(.data$team %in% team_select, .data$player_id != "unknown player") %>%
                    mutate(player_id = "Team total") %>% 
                    group_by(.data$player_id) %>%
                    dplyr::summarize(Tot = sum(.data$evaluation_code == "#" & .data$skill %in% c("Serve", "Attack", "Block")),
                                     # BP = sum(.data$evaluation_code == "#" & .data$skill %in% c("Serve", "Attack", "Block") & .data$serving_team == team_select),
                                     Nerr = sum((.data$evaluation %eq% "Error" & .data$skill %in% c("Serve", "Reception", "Attack", if (!as_for_datavolley) "Set", if (!as_for_datavolley) "Freeball")) | (!as_for_datavolley & .data$evaluation %eq% "Invasion" & .data$skill %eq% "Block") | (.data$evaluation %eq% "Blocked" & .data$skill %eq% "Attack")),
                                     'W-L' = .data$Tot - .data$Nerr))
    } else if (by == "set") {
        y <- plays(x)
        y$team_points <- if (team_select %eq% datavolley::home_team(y)) y$home_team_score else if (team_select %eq% datavolley::visiting_team(y)) y$visiting_team_score else NA_integer_
        vr_pts <- y %>% 
            group_by(.data$set_number) %>%
            dplyr::summarize(Ser = sum(.data$evaluation_code == "#" & .data$skill == "Serve" & .data$team %in% team_select, na.rm = TRUE),
                             Atk = sum(.data$evaluation_code == "#" & .data$skill == "Attack" & .data$team %in% team_select, na.rm = TRUE),
                             Blo = sum(.data$evaluation_code == "#" & .data$skill == "Block" & .data$team %in% team_select, na.rm = TRUE),
                             Tot = sum(.data$Ser, .data$Atk, .data$Blo),
                             "Op.Er" = max(.data$team_points, na.rm = TRUE) - .data$Ser - .data$Atk - .data$Blo) %>% 
            dplyr::relocate(Tot, .after = set_number) %>% 
            dplyr::slice(1:nrow(x$meta$result))
    }
    vr_pts
}
# Serve
vr_serve <- function(x, team, by = "player", team_select = noi){
    y <- plays(x)
    if (by == "player") {
        y %>% dplyr::filter(.data$team %in% team_select, .data$player_id != "unknown player", 
                            .data$skill == "Serve") %>% 
            group_by(.data$player_id) %>%
            dplyr::summarize(Tot = n(),
                             Err = sum(.data$evaluation %eq% "Error"),
                             Pts = sum(.data$evaluation %eq% "Ace"),
                             Neg = sum(.data$evaluation %eq% "Negative, opponent free attack"),
                             Pos = sum(.data$evaluation %eq% "Positive, no attack") + 
                                 sum(.data$evaluation %eq% "Positive, opponent some attack") + 
                                 sum(.data$evaluation %eq% "OK, no first tempo possible")) %>%
            bind_rows(
                y %>% dplyr::filter(.data$team %in% team_select, .data$player_id != "unknown player", .data$skill == "Serve") %>% 
                    mutate(player_id = "Team total")%>% group_by(.data$player_id) %>%
                    dplyr::summarize(Tot = n(),
                                     Err = sum(.data$evaluation %eq% "Error"),
                                     Pts = sum(.data$evaluation %eq% "Ace"),
                                     Neg = sum(.data$evaluation %eq% "Negative, opponent free attack"),
                                     Pos = sum(.data$evaluation %eq% "Positive, no attack") + 
                                         sum(.data$evaluation %eq% "Positive, opponent some attack") + 
                                         sum(.data$evaluation %eq% "OK, no first tempo possible"))
            )
    } else if(by == "set") {
        y %>% dplyr::filter(.data$team %in% team_select, .data$player_id != "unknown player", 
                            .data$skill == "Serve") %>% 
            group_by(.data$set_number) %>%
            dplyr::summarize(Tot = n(),
                             Err = sum(.data$evaluation %eq% "Error"),
                             Pts = sum(.data$evaluation %eq% "Ace"),
                             Neg = sum(.data$evaluation %eq% "Negative, opponent free attack"),
                             Pos = sum(.data$evaluation %eq% "Positive, no attack") + 
                                 sum(.data$evaluation %eq% "Positive, opponent some attack") + 
                                 sum(.data$evaluation %eq% "OK, no first tempo possible"))
    }
}
# Reception
vr_reception <- function(x, team, by = "player", file_type = "indoor", team_select = noi){
    y <- plays(x)
    if (by == "player"){
        y %>% 
            dplyr::filter(.data$team %in% team_select, .data$player_id != "unknown player", 
                          .data$skill == "Reception") %>% 
            group_by(.data$player_id) %>%
            dplyr::summarize(Tot = n(),
                             Err = sum(.data$evaluation %eq% "Error"),
                             'Neg%' = paste0(round(mean(.data$evaluation_code %in% c("-", "!", "/")), 2)*100, "%"),
                             'Pos%' = paste0(round(mean(.data$evaluation_code %in% c("+", "#", "#+")), 2)*100, "%"),
                             '(Exc%)' = paste0("(", round(mean(.data$evaluation_code %in% c("#")), 2)*100, "%)")) %>%
            bind_rows(
                y %>% 
                    dplyr::filter(.data$team %in% team_select, .data$player_id != "unknown player", 
                                  .data$skill == "Reception") %>% 
                    mutate(player_id = "Team total") %>%
                    group_by(.data$player_id) %>%
                    dplyr::summarize(Tot = n(),
                                     Err = sum(.data$evaluation %eq% "Error"),
                                     'Neg%' = paste0(round(mean(.data$evaluation_code %in% c("!", "/")), 2)*100, "%"),
                                     'Pos%' = paste0(round(mean(.data$evaluation_code %in% c("+", "#", "#+")), 2)*100, "%"),
                                     '(Exc%)' = paste0("(", round(mean(.data$evaluation_code %in% c("#")), 2)*100, "%)")))
    } else if (by == "set") {
        y %>% dplyr::filter(.data$team %in% team_select, .data$player_id != "unknown player", .data$skill == "Reception") %>% group_by(.data$set_number) %>%
            dplyr::summarize(Tot = n(),
                             Err = sum(.data$evaluation %eq% "Error"),
                             'Pos%' = paste0(round(mean(.data$evaluation_code %in% c("+", "#", "#+")), 2)*100, "%"),
                             'Neg%' = paste0(round(mean(.data$evaluation_code %in% c("!", "/")), 2)*100, "%"),
                             '(Exc%)' = paste0("(", round(mean(.data$evaluation_code %in% c("#")), 2)*100, "%)"))
    }
}
# Attack
vr_attack <- function(x, team, by = "player", team_select = noi){
    y <- plays(x)
    if (by == "player") {
        y %>% 
            dplyr::filter(.data$team %in% team_select, 
                          .data$player_id != "unknown player", 
                          .data$skill == "Attack") %>% 
            group_by(.data$player_id) %>%
            dplyr::summarize(Tot = n(),
                             Err = sum(.data$evaluation %eq% "Error"),
                             Blo = sum(.data$evaluation %eq% "Blocked"),
                             'Pts' = sum(.data$evaluation %eq% "Winning attack"),
                             'Pts%' = paste0(round(mean(.data$evaluation %eq% "Winning attack"), 2)*100, "%")) %>%
            bind_rows(
                y %>% 
                    dplyr::filter(.data$team %in% team_select, 
                                  .data$player_id != "unknown player", 
                                  .data$skill == "Attack") %>% 
                    mutate(player_id = "Team total") %>%
                    group_by(.data$player_id) %>%
                    dplyr::summarize(Tot = n(),
                                     Err = sum(.data$evaluation %eq% "Error"),
                                     Blo = sum(.data$evaluation %eq% "Blocked"),
                                     'Pts' = sum(.data$evaluation %eq% "Winning attack"),
                                     'Pts%' = paste0(round(mean(.data$evaluation %eq% "Winning attack"), 2)*100, "%")))
    } else if (by == "set") {
        y %>% 
            dplyr::filter(.data$team %in% team_select, 
                          .data$player_id != "unknown player", 
                          .data$skill == "Attack") %>% 
            group_by(.data$set_number) %>%
            dplyr::summarize(Tot = n(),
                             Err = sum(.data$evaluation %eq% "Error"),
                             Blo = sum(.data$evaluation %eq% "Blocked"),
                             'Pts' = sum(.data$evaluation %eq% "Winning attack"),
                             'Pts%' = paste0(round(mean(.data$evaluation %in% "Winning attack"), 2)*100, "%"))
    }
}
vr_freeball <- function(x, team, by = "player", team_select = noi){
    y <- plays(x)
    if (by == "player") {
        y %>% 
            dplyr::filter(.data$team %in% team_select, 
                          .data$player_id != "unknown player", 
                          .data$skill == "Freeball") %>% 
            group_by(.data$player_id) %>%
            dplyr::summarize(Tot = n(),
                             Err = sum(.data$evaluation %eq% "Error")) %>%
            bind_rows(
                y %>% 
                    dplyr::filter(.data$team %in% team_select, 
                                  .data$player_id != "unknown player", 
                                  .data$skill == "Freeball") %>% 
                    mutate(player_id = "Team total") %>%
                    group_by(.data$player_id) %>%
                    dplyr::summarize(Tot = n(),
                                     Err = sum(.data$evaluation %eq% "Error")))
    } else if (by == "set") {
        y %>% 
            dplyr::filter(.data$team %in% team_select, 
                          .data$player_id != "unknown player", 
                          .data$skill == "Freeball") %>% 
            group_by(.data$set_number) %>%
            dplyr::summarize(Tot = n(),
                             Err = sum(.data$evaluation %eq% "Error")) %>% 
            full_join(tibble(set_number = 1:nrow(x$meta$result),
                             Tot = 0,
                             Err = 0),
                      by = "set_number") %>% 
            select(-ends_with("y")) %>% 
            rename_with(~str_remove(.x, ".x")) %>% 
            replace_na(list(Tot = 0, Err = 0))
    }
}
# Block
vr_block <- function(x, team, by = "player", team_select = noi){
    y <- plays(x)
    if (by == "player"){
        y %>% 
            dplyr::filter(.data$team %in% team_select, 
                          .data$player_id != "unknown player") %>% 
            group_by(.data$player_id) %>%
            dplyr::summarize(Punto = sum(.data$evaluation %eq% "Winning block" & .data$skill %eq% "Block")) %>%
            bind_rows(
                y %>% 
                    dplyr::filter(.data$team %in% team_select, 
                                  .data$player_id != "unknown player") %>% 
                    mutate(player_id = "Team total") %>%
                    group_by(.data$player_id) %>%
                    dplyr::summarize(Punto = sum(.data$evaluation %eq% "Winning block" & .data$skill %eq% "Block")))
    } else if (by == "set") {
        y %>% 
            dplyr::filter(.data$team %in% team_select, .data$player_id != "unknown player") %>%
            group_by(.data$set_number) %>%
            dplyr::summarize(Punto = sum(.data$evaluation %eq% "Winning block" & .data$skill %eq% "Block"))  %>% 
            full_join(tibble(set_number = 1:nrow(x$meta$result),
                             Punto = 0),
                      by = "set_number") %>% 
            select(-ends_with("y")) %>% 
            rename_with(~str_remove(.x, ".x")) %>% 
            replace_na(list(Tot = 0, Err = 0))
    }
}