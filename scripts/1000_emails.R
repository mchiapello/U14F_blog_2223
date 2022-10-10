library(blastula)
library(glue)


# Prepare the text inputs
metadata <- tibble(
    coach = "Marco Chiapello",
    home_team = x$meta$teams$team[x$meta$teams$home_away_team == "*"],
    away_team = x$meta$teams$team[x$meta$teams$home_away_team == "a"],
    match_date = x$meta$match$date,
    campionato = x$meta$match$league,
    fase = x$meta$match$phase,
    giocatrice = if(x$meta$teams$team[x$meta$teams$home_away_team == "*"] == us){
        unique(paste0(x$meta$players_h$firstname, " ", x$meta$players_h$lastname))
    } else {
        unique(paste0(x$meta$players_v$firstname, " ", x$meta$players_v$lastname))
    },
    email = "marpello@gmail.com") %>% 
    mutate(nickname = str_remove(giocatrice, " "))


for(i in 1:nrow(metadata)){
    body_text <- 
        md(glue(
            "Ciao {word(metadata$giocatrice[i])},
            
            in allegato trovi i video da guardare prima del prossimo allenamento.
            
            I video si riferiscono alla partita giocata il {metadata$match_date[i]}, nel campionato 
            {metadata$campionato[i]} ({metadata$fase[i]}). 
            
            Abbiamo giocato {ifelse (metadata$home_team[i] == 'PGS Foglizzese', 'in casa ', 'fuori casa ')} contro
            {ifelse (metadata$home_team[i] == 'PGS Foglizzese', metadata$away_team[i], metadata$home_team[i])}.
            
            Abbiamo vinto la partita con i seguenti parziali: "
            
        ))
    
    # Generate the footer text
    footer_text <- "PGS Foglizzese campionato UISP U13 2021/2022"

    # Attachments
    file <- fs::dir_ls(paste0(out2, "/", metadata$nickname[i]), regexp = "html$")
    
    # Compose the email message
    email <- compose_email(body = body_text,
                           footer = footer_text)
    
    # Add attachments
    for(ii in 1:length(file)){
        email <- add_attachment(email, file[ii])
    }
    
    # Send email
    email %>%
        smtp_send(
            from = "marpello@gmail.com",
            to = metadata$email[i],
            subject = glue("Partita {metadata$home_team[i]} contro {metadata$away_team[i]}"),
            credentials = creds_file(file = "gmail_creds")
        )
    }

