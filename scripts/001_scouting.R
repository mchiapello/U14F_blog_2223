video_file <- dir_ls(out, regexp = "*mov$")

x <- dv_create(teams = teams, match = match, 
               players_h = readRDS("data/003_dati/players_fog"), 
               players_v = readRDS("data/003_dati/players_avv"))
## Court ref
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 1)

## enter the team lineups for set 1
x <- dv_set_lineups(x, set_number = 1, 
                    lineups = list(c(36,27,28,40,31,46), 
                                   c(1, 2, 3 , 4, 5, 6)), 
                    court_ref = refx,
                    setter_positions = c(4, 1))

ov_scouter(x, video_file = video_file,
           scouting_options = list(transition_sets = TRUE),
           launch_browser = TRUE)


# Update court reference
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 2800)

ov_scouter("~/Documents/personale/U14F_blog_2223/data/002_Partite/2022-10-15_VolleyParella/parella.ovs",
           video_file = video_file,
           scouting_options = list(transition_sets = TRUE),
           court_ref = refx,
           launch_browser = TRUE)

# Update court reference
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 2800)