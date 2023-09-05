# Packages ----------------------------------------------------------------

library(pROC)
library(tidyverse)
devtools::load_all()

# Data --------------------------------------------------------------------

dat_list <- readRDS("03-biostatistics/data/gene_data_clean.rds")
dat <- dplyr::bind_rows(dat_list, .id = "dataset")

# ROC and AUC for each gene across datasets

get_roc <- function(data){
  pROC::roc(debulking01 ~ x, data = data, quiet = TRUE)
}

get_roc_res <- function(fit){
  out <- data.frame(
    spec = fit$specificities,
    sens = fit$sensitivities,
    prev = mean(fit$response, na.rm = TRUE),
    auc = fit$auc[[1]],
    v_auc = var(fit$auc),
    s_auc = sqrt(var(fit$auc)),
    c = fit$thresholds
  )
  out$ppv <- with(out, ppv(sensitivity = sens, specificity = spec, prevalence = prev))
  return(out)
}

dat_roc <- dat |> 
  mutate(debulking01 = ifelse(debulking == "optimal", 0, 1)) |> 
  pivot_longer(!(matches("dataset") | matches("debulking")),
               names_to = "gene",
               values_to = "x") |> 
  drop_na() |> 
  group_by(gene) |> 
  nest() |> 
  ungroup() |> 
  mutate(roc = map(data, get_roc),
         roc_res = map(roc, get_roc_res))

all_roc <- dat_roc |> 
  select(gene, roc_res) 
  unnest(roc_res) |> 
  ggplot(aes(x = spec, 
             y = sens, 
             group = gene,
             color = auc)) +
  geom_line(alpha = 0.2) +
  scale_x_reverse() +
  labs(
    x = "Specificity",
    y = "Sensitivity",
    color = "AUC"
  )

all_auc <- dat_roc |> 
  select(gene, roc_res) |> 
  unnest(roc_res) |> 
  select(gene, auc) |> 
  distinct() |> 
  ggplot(aes(x = auc)) +
  geom_density(fill = "lightblue") +
  xlab("AUC") +
  ylab("Density")

# saving

all_plots <- list(
  all_roc = all_roc,
  all_auc = all_auc
)

saveRDS(all_plots, "03-biostatistics/objects/all_plots.rds")




  
