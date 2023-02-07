# Read video file
video_file  <- dir_ls(out, regexp = "*mp4$")

# Prepate team players
## BVC Foglizzese
elat("data/003_dati/players.tsv", team = "BCV Foglizzo", out = out)
## Avversari
prelat("data/002_Partite/2023-01-03_Calton/BVCCalton.txt", pathout = out, 
      team = "BCVCalton")
elat("data/002_Partite/2023-01-03_Calton/BCVCalton.tsv", team = "BCV Calton", out = out)


x <- dv_create(match = match, 
               teams = teams, 
               players_h = readRDS("data/002_Partite/2023-01-03_Calton/BCV Calton.RDS"), 
               players_v = readRDS("data/002_Partite/2023-01-03_Calton/BCV Foglizzo.RDS"))
x$meta$teams <- teams

## Court ref
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 1)
saveRDS(refx, paste0(out, "/mrefx.RDS"))

## enter the team lineups for set 1
x <- dv_set_lineups(x, set_number = 1, 
                    lineups = list(c(38,25,27,88,37,21), 
                                   c(40,9,48,28,31,30)), 
                    setter_positions = c(1, 2))

# Subset the attacks
x$meta$attacks <- read_csv("data/003_dati/myAttacks.csv")

# Do the scouting
ov_scouter(x, video_file = video_file,
           court_ref = readRDS(paste0(out, "/mrefx.RDS")),
           scouting_options = list(transition_sets = TRUE,
                                   attack_table = read_csv("data/003_dati/myAttacks.csv")),
           app_styling = list(review_pane_width = 50),
           launch_browser = TRUE)


# Update court reference
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 6000)

ov_scouter("data/002_Partite/2023-01-03_Calton/20230203_calton.ovs",
           scouting_options = list(transition_sets = TRUE,
                                   attack_table = read_csv("data/003_dati/myAttacks.csv")),
           app_styling = list(review_pane_width = 50),
           launch_browser = TRUE)

# Update court reference
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 2800)