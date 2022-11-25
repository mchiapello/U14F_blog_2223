tmp <- plays(x) |> 
    filter(team == noi, skill == "Freeball") |> 
    group_by(player_name, end_zone) |> 
    dplyr::summarize(n_serve = n()) %>%
    mutate(rate = n_serve/sum(n_serve)) %>%
    ungroup %>% 
    bind_cols(dv_xy(.$end_zone, end = "lower")) %>% 
    rename(end_x = x, end_y = y)  %>%
    ggplot(aes(end_x, end_y)) +
    geom_tile(aes(fill = rate), show.legend = FALSE) +
    geom_text(aes(label = n_serve), size = 2) +
    scale_fill_gradient2(low = "white",
                         high = "red",
                         name = "Scala Intensità") +
    ggcourt(labels = c("", ""), court = "lower", show_zones = FALSE) +
    theme(plot.title = element_text(hjust = .5, size = 15),
          plot.subtitle = element_text(hjust = .5, size = 12),
          plot.margin = unit(c(0, 0, 0, 0), "cm")) + 
    facet_wrap(vars(player_name)) +
    labs(title = "Zona di arrivo delle Freeball",
         subtitle = "Partita contro il Parella") 


ggsave(tmp, filename = "~/Downloads/FB.jpg", dpi = 300, units = "cm",
       width = 10, height = 10, scale = 1)



    

    
    plays(x) |> 
        mutate(pp = ifelse(lag(team_touch_id)))
    
    
    
    |> 
        filter(team == noi, skill == "Freeball",
               team_touch_id != pp) |> 
        select(point_id, team_touch_id, player_name, skill, end_zone) |> 
        group_by(player_name, end_zone) |> 
        dplyr::summarize(n_serve = n()) %>%
        mutate(rate = n_serve/sum(n_serve)) %>%
        ungroup %>% 
        bind_cols(dv_xy(.$end_zone, end = "lower")) %>% 
        rename(end_x = x, end_y = y)  %>%
        ggplot(aes(end_x, end_y)) +
        geom_tile(aes(fill = rate), show.legend = FALSE) +
        geom_text(aes(label = n_serve), size = 2) +
        scale_fill_gradient2(low = "white",
                             high = "red",
                             name = "Scala Intensità") +
        ggcourt(labels = c("", ""), court = "lower", show_zones = FALSE) +
        theme(plot.title = element_text(hjust = .5, size = 15),
              plot.subtitle = element_text(hjust = .5, size = 12),
              plot.margin = unit(c(0, 0, 0, 0), "cm")) + 
        facet_wrap(vars(player_name)) +
        labs(title = "Zona di arrivo delle Freeball",
             subtitle = "Partita contro il Parella") 
    