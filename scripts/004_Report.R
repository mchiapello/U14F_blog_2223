# Load libraries
library(datavolley)
library(volleyreport)

x <- dv_read(dir_ls(out2, regex = "dvw$"))

## generate the report
rpt <- vr_match_summary(x, style = "ov1", format = "paged_pdf")

file_move(rpt, paste0(out2, "/", str_replace(basename(dir_ls(out2, regex = "dvw$")),
                                             "dvw", "pdf")))


