oo <- ov_default_shortcuts()
names(oo)

# video_rewind_1_30
oo[[9]] <- c("b", "1")
# video_forward_1_30
oo[[13]] <- c(",", "2")

# video_rewind_10
oo[[12]] <- c("h", "3")
# video_forward_10
oo[[16]] <- c(";", "4") 

# video_rewind_2
oo[[11]] <- c("j", "5")
# video_forward_2
oo[[15]] <- c("l", "6")

# video_rewind_0.1
oo[[10]] <- c("n", "7")
# video_forward_0.1
oo[[14]] <- c("m", "8")

saveRDS(oo, "data/003_dati/shortcuts.RDS")
