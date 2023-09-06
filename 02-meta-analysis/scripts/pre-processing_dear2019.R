library(metafor)

df1 <- read.csv("02-meta-analysis/objects/dear2019.csv")
#datMA <- escalc(measure="OR",ai=EYES.ASB.YES, bi=EYES.ASB.NO, ci=CTRL.ASB.YES, di=CTRL.ASB.N, data=df1)

saveRDS(datMA, "02-meta-analysis/objects/dear2019_clean.rds")
save(datMA, file = "data/dear2019.rda")