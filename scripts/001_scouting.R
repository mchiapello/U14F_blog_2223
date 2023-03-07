# Read video file
video_file  <- dir_ls(out, regexp = "*mp4$")

# Prepate team players
## BVC Foglizzese
elat("data/003_dati/players.tsv", team = "BCV Foglizzo", out = out)
## Avversari
prelat(paste0(out, "/opp.txt"), pathout = out, team = teams$team[teams$team != "BCV Foglizzo"])
elat(paste0(out, "/", teams$team[teams$team != "BCV Foglizzo"], ".tsv"), team = teams$team[teams$team != "BCV Foglizzo"], out = out)


x <- dv_create(match = match, 
               teams = teams, 
               players_v = readRDS(paste0(out, "/", teams$team[teams$team != "BCV Foglizzo"], ".RDS")), 
               players_h = readRDS(paste0(out, "/BCV Foglizzo.RDS")))
x$meta$teams <- teams

## Court ref
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 1)
saveRDS(refx, paste0(out, "/mrefx.RDS"))

## enter the team lineups for set 1
x <- dv_set_lineups(x, set_number = 1, 
                    lineups = list(c(31,30,36,9,27,28), 
                                   c(7,2,24,6,14,9)), 
                    setter_positions = c(3, 1))

# Subset the attacks
x$meta$attacks <- read_csv("data/003_dati/myAttacks.csv")

# Do the scouting
ov_scouter(x, video_file = video_file,
           court_ref = readRDS(paste0(out, "/mrefx.RDS")),
           scouting_options = list(transition_sets = TRUE,
                                   attack_table = read_csv("data/003_dati/myAttacks.csv")),
           app_styling = list(review_pane_width = 50),
           launch_browser = TRUE)

# Restart scouting
ov_scouter(dir_ls(out, regexp = "ovs$"),
           scouting_options = list(transition_sets = TRUE,
                                   attack_table = read_csv("data/003_dati/myAttacks.csv")),
           app_styling = list(review_pane_width = 50),
           launch_browser = TRUE)

# Update court reference
# refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 2800)
# out <- "/Users/chiapell/Documents/personale/PALLAVOLO/U14F_blog_2223/data/002_Partite/2023-03-05_To.volley"



















