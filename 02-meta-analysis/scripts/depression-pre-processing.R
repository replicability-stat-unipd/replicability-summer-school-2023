library(metapsyData)

dat <- getData("depression-psyctr")$data

# selecting only CBT as therapy, waiting list as control and format as individual

idx <- dat$condition_arm1 == "cbt" & dat$condition_arm2 == "wl" & dat$format %in% c("grp", "ind") & dat$age_group %in% c("adul", "yadul", "old")

# selecting relevant columns

cols <- c("study", "age_group", "mean_age", "country", "format", ".g", ".g_se")

dat_clean <- dat[idx, cols]

dat_clean$id <- 1:nrow(dat_clean)

dat_clean <- dplyr::select(dat_clean, id, dplyr::everything())

names(dat_clean) <- c("id", "study", "age_group", "mean_age", "country", "format", "yi", "sei")

dat_clean <- lapply(split(dat_clean, dat_clean$study), function(x) if(nrow(x) > 1) x[sample(1:nrow(x), 1), ] else x)
dat_clean <- dplyr::bind_rows(dat_clean)

rownames(dat_clean) <- NULL

saveRDS(dat_clean, "04-meta-analysis/objects/depression.rds")

dat_clean
