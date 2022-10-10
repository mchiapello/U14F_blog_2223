dvw <- dir_ls(out, regexp = "dvw$")
x <- dv_read(dvw)
dv_meta_video(x) <- "https://youtu.be/EjNh9FUwPJ0"
# Remove local mp4 file
file_delete(dir_ls(out, regexp = "MOV$"))
out2 <- out

## extract the plays
px <- datavolley::plays(x)

px2 <- px %>% 
    filter(!is.na(player_id),
           team == "PGS Foglizzese") %>% 
    mutate(Nome = player_name,
           fondamentale = skill)

px3 <- px2 %>% 
    filter(!is.na(video_time)) %>% 
    group_by(Nome, fondamentale) %>% 
    nest() %>% 
    arrange(Nome, fondamentale)

## define columns to show in the table
extra_cols <- c("player_name", "evaluation", "set_number",
                "home_team_score", "visiting_team_score")

setwd(out)
map(px3 %>% filter(Nome != "unknown player") %>% 
        mutate(Nome = str_remove(Nome, " ")) %>% 
        pull(Nome) %>% 
        unique, fs::dir_create)
setwd(here::here())

out2 <- out
px3 <- px3 %>% 
    filter(Nome != "unknown player") %>%
    mutate(out = map(data, ovideo::ov_video_playlist, meta = x$meta,
                     extra_cols = extra_cols),
           outfile = paste0(out2, "/", str_remove(Nome, " "), 
                            "/", fondamentale, ".html"))

px4 <- px3 %>% 
    filter(fondamentale %in% c("Attack", "Reception", "Serve", "Set"))

for(i in 1:nrow(px4)){
    ovideo::ov_playlist_to_html(px4$out[[i]], 
                        table_cols = extra_cols,
                        outfile = px4$outfile[i])
}

file_copy(dir_ls(out2, regexp = "dvw$"), "data/000_allenamenti/all/")

