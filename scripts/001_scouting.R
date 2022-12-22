video_file  <- dir_ls(out, regexp = "*mp4$")



x <- dv_create(teams = teams, match = match, 
                   players_h = readRDS("data/003_dati/players_fog"), 
               players_v = readRDS("data/003_dati/players_avv"))

## Court ref
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 1)
saveRDS(refx, "data/003_dati/mrefx.RDS")

## enter the team lineups for set 1
x <- dv_set_lineups(x, set_number = 5, 
                    lineups = list(c(28,48,36,31,9,40), 
                                   c(1, 2, 3 , 4, 5, 6)), 
                    setter_positions = c(3, 1))

# Subset the attacks
x$meta$attacks <- read_csv("data/003_dati/myAttacks.csv")

# Do the scouting
ov_scouter(x, video_file = video_file,
           court_ref = readRDS("data/003_dati/mrefx.RDS"),
           scouting_options = list(transition_sets = TRUE,
                                   attack_table = read_csv("data/003_dati/myAttacks.csv")),
           app_styling = list(review_pane_width = 50),
           launch_browser = TRUE)


# Update court reference
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 6000)

ov_scouter("data/002_Partite/2022-12-17_Leini/20221217_leini.ovs",
           # video_file = video_file,
           scouting_options = list(transition_sets = TRUE),
           app_styling = list(review_pane_width = 50),
           launch_browser = TRUE)

# Update court reference
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 2800)