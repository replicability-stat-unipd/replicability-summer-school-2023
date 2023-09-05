library(metafor)
library(ggplot2)

# set.seed(2023)

k <- seq(10, 100, 10)
n <- seq(10, 100, 20)
es <- 0.3
tau2 <- 0.1
alpha <- 0.05
nsim <- 1e3

sim <- tidyr::expand_grid(k, n, es, tau2)
sim$power <- 0

# handle errors, return NA
srma <- purrr::possibly(rma, otherwise = NA)

for(i in 1:nrow(sim)){ # iterate for each condition
  pval <- rep(0, nsim)
  for(j in 1:nsim){ # iterate for each simulation
    dat <- sim_studies(k = sim$k[i], 
                       theta = sim$es[i], 
                       tau2 = sim$tau2[i],
                       n0 = sim$n[i],
                       n1 = sim$n[i])
    fit <- rma(yi, vi, data = dat, method = "REML")
    pval[j] <- fit$pval
  }
  sim$power[i] <- mean(pval <= alpha) # calculate power
  filor::pb(nrow(sim), i)
}

saveRDS(sim, here("04-meta-analysis/objects/power-example.rds"))