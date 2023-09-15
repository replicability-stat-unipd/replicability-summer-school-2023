library(metafor)

final_database <- readxl::read_xlsx("02-meta-analysis/objects/oliveira2023.xlsx")
final_database$mean.exp.pos <- as.numeric(final_database$mean.exp.pos)
final_database$mean.control.pos <- as.numeric(final_database$mean.control.pos)
final_database$sd.control.pos <- as.numeric(final_database$sd.control.pos)
final_database$sd.exp.pos <- as.numeric(final_database$sd.exp.pos)

oliveira2023 <- escalc(measure = "SMD", n1i = n.exp.pos, n2i = n.control.pos, m1i = mean.exp.pos, m2i = mean.control.pos, sd1i = sd.exp.pos, sd2i = sd.control.pos, data = final_database, slab=paste(Study, Year, sep=", "))

saveRDS(oliveira2023, "02-meta-analysis/objects/oliveira2023.rds")
save(oliveira2023, file = "data/oliveira2023.rda")