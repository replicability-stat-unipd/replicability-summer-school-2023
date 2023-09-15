# Packages

library(metafor)

# Downloading data

download.file("https://osf.io/download/k7xub", 
              destfile = "04-replication-methods/objects/hagger2016_raw.csv")

# Importing and pre-processing (see https://osf.io/v2t5c)

# Import the data
RTdat <- read.csv("04-replication-methods/objects/hagger2016_raw.csv")
RTdat <- RTdat[order(RTdat$Study.name), ]
### random-effects model meta-analysis 
# modeled after http://www.metafor-project.org/doku.php/tips:assembling_data_smd
effectSizesAll<- escalc(measure="SMD", #standardized mean difference
                        m1i= Ego.Depletion.Mean, m2i= Control.Mean,
                        sd1i=Ego.Depletion.Std.Dev, sd2i= Control.Std.Dev,
                        n1i=Ego.Depletion.Sample.size, n2i=Control.Sample.size,
                        data= RTdat)

# check results
# res <- rma(data=effectSizesAll, yi,vi,  method="REML", slab=paste(Study.name))

# select only important columns

dat <- effectSizesAll[, c("Ego.Depletion.Mean", "Ego.Depletion.Std.Dev",
                          "Control.Mean", "Control.Std.Dev", "Ego.Depletion.Sample.size",
                          "Control.Sample.size",
                          "yi", "vi")]

names(dat) <- c("m_exp", "sd_exp", "m_ctrl", "sd_ctrl", "n_exp", "n_ctrl", "yi", "vi")
dat$id <- paste0("lab", 1:nrow(dat))

dat <- dplyr::select(dat, id, dplyr::everything())
dat$type <- "replication"

# adding the original effect

orig <- data.frame(id = 0, NA, NA, NA, NA, NA, NA, yi = 0.62, vi = 0.02^2, type = "original")
names(orig) <- names(dat)

hagger2016 <- rbind(orig, dat)

# saving

saveRDS(hagger2016, "04-replication-methods/objects/hagger2016.rds")
save(hagger2016, file = "data/hagger2016.rda")