library(metafor)

dear2019 <- read.csv("02-meta-analysis/objects/dear2019.csv")
#datMA <- escalc(measure="OR",ai=EYES.ASB.YES, bi=EYES.ASB.NO, ci=CTRL.ASB.YES, di=CTRL.ASB.N, data=df1)

saveRDS(dear2019, "02-meta-analysis/objects/dear2019.rds")
save(dear2019, file = "data/dear2019.rda")
