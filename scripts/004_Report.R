# Load libraries
library(datavolley)
library(volleyreport)

x <- dv_read(dir_ls(out, regex = "dvw$"))
# x <- readRDS("~/Library/Application Support/ovscout2/autosave/ovscout2-1698f71126d64.rds")

## generate the report
rpt <- vr_match_summary(x, style = "ov1", format = "paged_pdf")

file_move(rpt, paste0(out2, "/avanzato.pdf"))


