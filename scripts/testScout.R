library(datavolley)
library(tidyverse)
library(ggrepel)
library(patchwork)

x <- dv_read("data/002_Partite/all/PVLcerealterra.dvw")
px <- plays(x)

    
px2 <- px %>% 
    as_tibble() %>% 
    select(point_id, team, player_number, team_touch_id, skill, evaluation, point_won_by, phase, 
           home_score_start_of_point, visiting_score_start_of_point) %>% 
    drop_na() %>% 
    mutate(evaluation = case_when(skill == "Serve" & 
                                      evaluation %in% c("Negative, opponent free attack") ~ "Negativo",
                                  skill == "Serve" & 
                                      evaluation %in% c("OK, no first tempo possible",
                                                        "Positive, opponent some attack",
                                                        "Positive, no attack") ~ "Positivo",
                                  skill == "Serve" & 
                                      evaluation %in% c("Ace") ~ "Punto",
                                  skill == "Attack" & 
                                      evaluation %in% c("Poor, easily dug") ~ "Negativo",
                                  skill == "Attack" & 
                                      evaluation %in% c("Blocked for reattack",
                                                        "Positive, good attack") ~ "Positivo",
                                  skill == "Attack" & 
                                      evaluation %in% c("Winning attack") ~ "Punto",
                                  skill == "Block" & 
                                      evaluation %in% c("Poor, opposition to replay") ~ "Negativo",
                                  skill == "Dig" & 
                                      evaluation %in% c("Ball directly back over net") ~ "Negativo",
                                  skill == "Dig" & 
                                      evaluation %in% c("Good dig") ~ "Positivo",
                                  skill == "Freeball" & 
                                      evaluation %in% c("Good", "OK, only high set possible") ~ "Positivo",
                                  skill == "Freeball" & 
                                      evaluation %in% c("Poor") ~ "Negativo",
                                  skill == "Reception" & 
                                      evaluation %in% c("Positive, attack",
                                                        "Perfect pass") ~ "Positivo",
                                  skill == "Reception" & 
                                      evaluation %in% c("Negative, limited attack",
                                                        "OK, no first tempo possible",
                                                        "Poor, no attack") ~ "Negativo",
                                  skill == "Set" & 
                                      evaluation %in% c("Poor") ~ "Negativo",
                                  skill == "Set" & 
                                      evaluation %in% c("Positive") ~ "Positivo",
                                  TRUE ~ evaluation)) %>% 
    mutate(col = case_when(evaluation == "Error" ~ "firebrick",
                           evaluation == "Punto" ~ "green",
                           evaluation == "Negativo" ~ "lightblue",
                           evaluation == "Positivo" ~ "orange")) %>% 
    group_by(point_id) %>% 
    nest()


y <- px2$data[[1]]

pbp <- function(y){
    
}


attack_rate <- px %>%
    dplyr::filter(skill == "Attack",
                  team != "PGS Foglizzese") %>%
    filter(grepl("2|3|4", start_zone)) %>% 
    group_by(team, start_zone, end_zone) %>%
    dplyr::summarize(n_attacks = n()) %>%
    mutate(rate = n_attacks/sum(n_attacks)) %>%
    ungroup %>% 
    bind_cols(dv_xy(.$start_zone, end = "upper")) %>% 
    rename(start_x = x, start_y = y) %>% 
    bind_cols(dv_xy(.$end_zone, end = "lower")) %>% 
    rename(end_x = x, end_y = y)

# Posto 2
p1 <- attack_rate %>%
    filter(start_zone == 2) %>% 
    ggplot(aes(end_x, end_y)) +
    geom_tile(aes(fill = rate), show.legend = FALSE) +
    geom_text(aes(label = n_attacks)) +
    scale_fill_gradient2(low = "white",
                         high = "red",
                         name = "Scala Intensità") +
    ggcourt(labels = c("", ""), court = "lower") +
    ggforce::geom_circle(aes(x0=1, y0=3.5, r=.1),
                fill='red', lwd=1, inherit.aes=FALSE) +
    labs(title = "Attacco da P2") +
    theme(plot.title = element_text(hjust = .5))

# Posto 3
p2 <- attack_rate %>%
    filter(start_zone == 3) %>% 
    ggplot(aes(end_x, end_y)) +
    geom_tile(aes(fill = rate), show.legend = FALSE) +
    geom_text(aes(label = n_attacks)) +
    scale_fill_gradient2(low = "white",
                         high = "red",
                         name = "Scala Intensità") +
    ggcourt(labels = c("", ""), court = "lower") +
    ggforce::geom_circle(aes(x0=2, y0=3.5, r=.1),
                         fill='red', lwd=1, inherit.aes=FALSE) +
    labs(title = "Attacco da P3") +
    theme(plot.title = element_text(hjust = .5))

# Posto 4
p3 <- attack_rate %>%
    filter(start_zone == 4) %>% 
    ggplot(aes(end_x, end_y)) +
    geom_tile(aes(fill = rate), show.legend = FALSE) +
    geom_text(aes(label = n_attacks)) +
    scale_fill_gradient2(low = "white",
                         high = "red",
                         name = "Scala Intensità") +
    ggcourt(labels = c("", ""), court = "lower") +
    ggforce::geom_circle(aes(x0=3, y0=3.5, r=.1),
                         fill='red', lwd=1, inherit.aes=FALSE) +
    labs(title = "Attacco da P4") +
    theme(plot.title = element_text(hjust = .5))

p1 + p2 + p3 
