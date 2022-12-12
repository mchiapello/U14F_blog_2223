library(fs)
library(tidyverse)
library(datavolley)
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

team_select = "PGS Foglizzese"
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


tmp <- px |> 
    select(match_id, point_id, set_number, video_time, team_touch_id, home_team,
           home_team_score, visiting_team, visiting_team_score,
           team, player_number, skill, evaluation, phase, 
           point_won_by) |> 
    na.omit()

tmp |> 
    filter(match_id == "8b4105fc4dc18b22fd05222877b713fd",
           point_id == 20)


tmp2 <- tmp |> 
    group_by(match_id, set_number) |> 
    nest()

x <- tmp2$data[[1]]

rally <- function(x, home_team = "PGS Foglizzese"){
    y <- x |> 
        group_by(point_id) |> 
        slice_tail() |> 
        ungroup() |> 
        mutate(duration = lead(video_time) - video_time) 
        
     home <- y |> 
         filter(point_won_by == home_team) |> 
         mutate(actionH = paste(player_number, skill, evaluation,
                               sep = " ")) |> 
         select(point_id, point_won_by, actionH)
     
     away <- y |> 
         filter(point_won_by != home_team) |> 
         mutate(actionA = paste(evaluation,skill, player_number, 
                                sep = " ")) |> 
         select(point_id, point_won_by, actionA)
     
     oo <- home |> 
         bind_rows(away) |> 
         arrange(point_id) |> 
         left_join(y |> select(point_id, home_team_score,
                               visiting_team_score)) |> 
         mutate(action = coalesce(actionH, actionA)) |> 
         select(-actionA, -actionH) |> 
         pivot_wider(names_from = point_won_by, 
                     values_from = action) |> 
         mutate(score = paste0(home_team_score, " - ", visiting_team_score)) |>
         select(-point_id, -home_team_score, -visiting_team_score) %>%
         replace(is.na(.), "")
     
     indHE <- oo |> 
         mutate(ind = row_number()) |> 
         filter(if_any(1, ~ grepl("Error", .))) |> 
         pull(ind)     
      indHP <- oo |> 
         mutate(ind = row_number()) |> 
         filter(if_any(1, ~ grepl("Winning|Ace", .))) |> 
         pull(ind)
      indAE <- oo |> 
          mutate(ind = row_number()) |> 
          filter(if_any(2, ~ grepl("Error", .))) |> 
          pull(ind)     
      indAP <- oo |> 
          mutate(ind = row_number()) |> 
          filter(if_any(2, ~ grepl("Winning|Ace", .))) |> 
          pull(ind)
      
     oo[, c(1, 3, 2)] |> 
         gt() |> 
     tab_style(
         style = cell_text(color = "red"),
         locations = cells_body(
             columns = c(`PGS Foglizzese`),
             rows = indHE
         )
     ) |> 
         tab_style(
             style = cell_text(color = "green"),
             locations = cells_body(
                 columns = c(`PGS Foglizzese`),
                 rows = indHP
             )
         ) |> 
         tab_style(
             style = cell_text(color = "red"),
             locations = cells_body(
                 columns = c(VolleyParella),
                 rows = indAE
             )
         ) |> 
         tab_style(
             style = cell_text(color = "green"),
             locations = cells_body(
                 columns = c(VolleyParella),
                 rows = indAP
             )
         )
     # tab_style(
     #     style = cell_text(color = "red"),
     #     locations = cells_body(
     #         columns = c({{home_team}}),
     #         rows = {{home_team}} == "5 Attack Error"
     #     )
     # )
}




head(gtcars, 8) %>%
    dplyr::select(model:trim, mpg_city = mpg_c, mpg_hwy = mpg_h) %>%  
    gt(rowname_col = "model") %>% 
    tab_style(
        style = cell_text(color = "red"),
        locations = cells_body(
            columns = c(trim),
            rows = trim == "Base Convertible"
        )
    )

head(mtcars[,1:5]) %>% 
    tibble::rownames_to_column("car") %>% 
    gt() %>% 
    gt_highlight_rows(
    rows = c(1,3,5), 
    fill = "lightgrey",
    bold_target_only = TRUE,
    target_col = car
)






