video_file <- dir_ls(out, regexp = "*mov$")

x <- dv_create(teams = teams, match = match, 
               players_h = readRDS("data/003_dati/players_fog"), 
               players_v = readRDS("data/003_dati/players_avv"))
## Court ref
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 1)

## enter the team lineups for set 1
x <- dv_set_lineups(x, set_number = 1, 
                    lineups = list(c(9,31,40,28,46,36), 
                                   c(1, 2, 3 , 4, 5, 6)), 
                    setter_positions = c(3, 1))

# Subset the attacks
x$meta$attacks <- read_csv("data/003_dati/myAttacks.csv")

# Do the scouting
ov_scouter(x, video_file = video_file,
           court_ref = refx,
           scouting_options = list(transition_sets = TRUE,
                                   attack_table = read_csv("data/003_dati/myAttacks.csv")),
           launch_browser = TRUE)


# Update court reference
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 2800)

ov_scouter("~/Library/Application Support/ovscout2/autosave/ovscout2-12387e6a0572.ovs",
           video_file = video_file,
           scouting_options = list(transition_sets = TRUE),
           court_ref = refx,
           launch_browser = TRUE)

# Update court reference
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 2800)