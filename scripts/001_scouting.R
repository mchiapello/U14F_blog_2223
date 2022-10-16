video_file <- dir_ls(out, regexp = "*mov$")

x <- dv_create(teams = teams, match = match, 
               players_h = readRDS("data/003_dati/players_fog"), 
               players_v = readRDS("data/003_dati/players_avv"))

## enter the team lineups for set 1
x <- dv_set_lineups(x, set_number = 1, 
                    lineups = list(c(36,27,28,40,31,46), 
                                   c(1, 2, 3 , 4, 5, 6)), 
                    setter_positions = c(4, 1))

ov_scouter(x, video_file = video_file,
           scouting_options = list(transition_sets = TRUE),
           launch_browser = TRUE)


ov_scouter("~/Documents/personale/U14F_blog_2223/data/000_allenamenti/2022-10-07/20221007_A016 - HD 1080p_set2done.ovs",
           video_file = video_file,
           scouting_options = list(transition_sets = TRUE,
                                   nblockers = FALSE),
           launch_browser = TRUE)
