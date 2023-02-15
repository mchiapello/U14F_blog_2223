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
    }) %>% 
    left_join(read_tsv(paste0(here::here(), "/data/003_dati/email.tsv")) %>% 
                  unite("giocatrice", Nome:Cognome, sep = " ")) %>% 
    mutate(nickname = str_remove(giocatrice, " ")) %>% 
    filter(!nickname %in% c("NoemiPascarella", "CiravoloAlice"))


for(i in 3:nrow(metadata)){
    body_text <- 
        md(glue(
            "Ciao {word(metadata$giocatrice[i])},
            
            in allegato trovi i video da guardare prima del prossimo allenamento.
            
            I video si riferiscono alla partita giocata il {format(metadata$match_date[i], '%d %b %Y')}, nel campionato 
            {metadata$campionato[i]} contro il
            {ifelse (metadata$home_team[i] == 'PGS Foglizzese', metadata$away_team[i], metadata$home_team[i])}.
            
            
            Scarica i file allegati e aprili con un web browser per vedere i video delle tue azioni con la valutazione del fondamentale (in inglese). 
            Sono divisi per fondamentale, sulla destra puoi vedere la lista delle azioni e sotto il video trovi i controlli del video.
            "
        ))
    
    # Generate the footer text
    footer_text <- "Basso Canavese Foglizzo - Campionato FIPAV U14 2022/2023"

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
            from = "chiapello.m@gmail.com",
            to = metadata$email[i],
            subject = glue("Partita {metadata$home_team[i]} contro {metadata$away_team[i]}"),
            credentials = creds_key("gmail")
        )
    message(paste0("Inviata a ", metadata$giocatrice[i]))
    }

# Delete files
fs::dir_delete(unique(fs::path_dir(fs::dir_ls(paste0(out2, "/", metadata$nickname), regexp = "html$"))))



