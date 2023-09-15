library(metafor)

# original study by Eskine and colleagues 2011

orig <- data.frame(
    id = 0,
    m_exp = 78.34,
    s_exp = 10.83,
    n_exp = 15,
    m_ctrl = 61.58,
    s_ctrl = 16.88,
    n_ctrl = 21,
    type = "original"
)

orig <- metafor::escalc("SMD", 
                        m1i = m_exp, m2i = m_ctrl, 
                        sd1i = s_exp, sd2i = s_ctrl,
                        n1i = n_exp, n2i = n_ctrl,
                        data = orig)

# replication study by Ghelfi and colleagues 2020
# download.file("https://osf.io/download/f9jmr/", "04-replication-methods/objects/ghelfi2020_raw.RData")

get_from_rdata <- function(file, obj){
    temp <- new.env()
    suppressWarnings(load(file, env = temp))
    temp[[obj]]
}

dat <- get_from_rdata("04-replication-methods/objects/ghelfi2020_raw.RData", "results_data_wide")

dat <- dat[dat$contrast == "bvc", ]
dat <- dplyr::select(dat, study, m1, m2, sd1, sd2, n1, n2, g, es.g.v)
dat$type <- "replication"
names(dat) <- c("id", "m_exp", "m_ctrl", "s_exp", "s_ctrl", "n_exp", "n_ctrl", "yi", "vi", "type")

# combining

ghelfi2020 <- rbind(orig, dat)

# saving

saveRDS(ghelfi2020, "04-replication-methods/objects/ghelfi2020.rds")
save(ghelfi2020, file = "data/ghelfi2020.rda")