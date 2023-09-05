# Packages ----------------------------------------------------------------

library(tidyverse)
library(distributional)
library(ggdist)
library(here)
library(latex2exp)
library(ltxplot)

ltxplot::load_theme_ltx()

# Functions ---------------------------------------------------------------

theme_rfig <- function(size = 15){
  ltxplot::theme_latex(base_size = size)
}

# Equal-vs-Random Effect --------------------------------------------------

equal_effects <- data.frame(
  id = 1:4,
  yi = rep(0.5, 4),
  vi = c(0.01, 0.02, 0.1, 0.05),
  model = "Equal-Effects",
  di = 0.5
)

equal_effects$note <- sprintf("$y_i = \\theta + \\epsilon_i$")

random_effect <- data.frame(
  id = 1:4,
  yi = c(-0.1, 0.4, 0.7, 0.25),
  vi = c(0.01, 0.02, 0.1, 0.05),
  model = "Random-Effects"
)

random_effect$note <- sprintf("$y_i = \\mu_{\\theta} + \\delta_i + \\epsilon_i$")

random_effect$di <- mean(random_effect$yi)

models <- rbind(equal_effects, random_effect)
models$dist <- map2(models$yi, sqrt(models$vi), distributional::dist_normal)
models$note <- latex2exp::TeX(models$note, output = "character")
models$delta <- models$yi - models$di

set.seed(2036)
models$obs <- mapply(function(m, s) rnorm(1, m, s), models$yi, sqrt(models$vi))

p_equal_down <- ggplot(filter(models, model == "Equal-Effects"), aes(y = factor(id))) +
  geom_vline(aes(xintercept = di), linetype = "dashed", alpha = 0.5) +
  stat_dist_halfeye(aes(dist = dist), .width = 0.95) +
  xlim(c(-1,2)) +
  facet_wrap(~model, scales = "free_x") +
  ylab("Study") +
  xlab(TeX("$y_i$")) +
  theme_rfig() +
  theme(strip.text = element_text(family = "lmroman"),
        strip.text.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank()) +
  geom_label(aes(x = di, y = 0.6, label = note), parse = TRUE, size = 7, label.size = NA) +
  geom_segment(aes(x = di + delta, xend = di, y = id-0.08, yend = id-0.08),
               position = position_dodge2(width = 1, padding = 1)) +
  geom_point(aes(x = obs, y = factor(id)), color = "firebrick2", size = 2, shape = 15) +
  geom_point(aes(x = yi, y = id-0.08, alpha = model), show.legend = FALSE) +
  scale_alpha_manual(values = c(0, 1))

p_random_down <- ggplot(filter(models, model == "Random-Effects"), aes(y = factor(id))) +
  geom_segment(aes(x = di + delta, xend = di + delta,
                   y = factor(id), yend = Inf),
               alpha = 0.3) +
  geom_vline(aes(xintercept = di), linetype = "dashed", alpha = 0.5) +
  stat_dist_halfeye(aes(dist = dist), .width = 0.95) +
  xlim(c(-1,2)) +
  facet_wrap(~model, scales = "free_x") +
  ylab("Study") +
  xlab(TeX("$y_i$")) +
  theme_rfig() +
  theme(strip.text = element_text(family = "lmroman"),
        strip.text.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank()) +
  geom_label(aes(x = di, y = 0.6, label = note), parse = TRUE, size = 7, label.size = NA) +
  # geom_segment(aes(x = di + delta, xend = di, y = id-0.08, yend = id-0.08),
  #              position = position_dodge2(width = 1, padding = 1)) +
  geom_point(aes(x = obs, y = factor(id)), color = "firebrick2", size = 2, shape = 15) +
  geom_point(aes(x = yi, y = id-0.08, alpha = model), show.legend = FALSE) +
  scale_alpha_manual(values = c(0, 1)) +
  geom_segment(aes(x = di + delta, xend = di + delta,
                   y = factor(id), yend = Inf),
               alpha = 0.3)

up_left <- data.frame(
  id = 1,
  theta = 0.5
)

up_right <- data.frame(
  id = 1,
  mu = 0.3125,
  tau2 = 0.1
)

up_right$dist <- distributional::dist_normal(up_right$mu, sqrt(up_right$tau2))

p_up_left <- ggplot(up_left) +
  geom_label(aes(x = theta, y = 3), 
             label = TeX("$\\theta$"), 
             parse = TRUE,
             size = 7,
             label.size = NA) +
  ylim(c(1, 5)) +
  xlim(c(-1, 2)) +
  cowplot::theme_nothing() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank())

p_up_right <- ggplot(up_right) +
  stat_halfeye(aes(y = id, dist = dist), .width = 0.95, fill = "#7FB3D5") +
  ylim(c(1, 5)) +
  xlim(c(-1, 2)) +
  cowplot::theme_nothing() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank()) +
  geom_label(aes(x = mu, y = 3), 
             label = TeX("$N(\\mu_{\\theta}, \\tau^2)$"), 
             parse = TRUE,
             size = 7,
             label.size = NA)


p_equal <- cowplot::plot_grid(p_up_left, p_equal_down, ncol = 1, align = "v",
                              rel_heights = c(0.33, 0.66))
p_random <- cowplot::plot_grid(p_up_right, p_random_down, ncol = 1, align = "v",
                               rel_heights = c(0.33, 0.66))


equal_vs_random <- cowplot::plot_grid(p_equal, p_random, ncol = 2)

# Metaregression with binary predictor ------------------------------------

binary_metareg <- data.frame(
  id = 1:6,
  yi = c(0.1, -0.1, -0.1, 0.5, 0.7, 0.8),
  vi = c(0.001, 0.002, 0.001, 0.001, 0.002, 0.003),
  cond = rep(c("a", "b"), each = 3)
)

binary_metareg$dist <- map2(binary_metareg$yi, 
                            sqrt(binary_metareg$vi), 
                            dist_normal)

binary_metareg$note <- sprintf("Condition %s", toupper(binary_metareg$cond))

mm <- c(mean(binary_metareg$yi[binary_metareg$cond == "a"]),
        mean(binary_metareg$yi[binary_metareg$cond == "b"]))

binary_metareg$cond_mean <- rep(mm, each = 3)
binary_metareg$res <- binary_metareg$yi - binary_metareg$cond_mean
binary_metareg$gm <- mean(binary_metareg$yi)

xlim <- c(mean(mm) - 1, mean(mm) + 1)

set.seed(2027)
binary_metareg$obs <- rnorm(nrow(binary_metareg), binary_metareg$yi, sqrt(binary_metareg$vi))

plot_metareg_bin <- ggplot(binary_metareg,
                           aes(y = id)) +
  geom_segment(aes(x = gm, xend = obs, y = id-0.2, yend = id-0.2),
               color = "darkgreen", size = 1) +
  geom_segment(aes(x = cond_mean, xend = obs, y = id-0.2, yend = id-0.2),
               color = "firebrick", size = 1) +
  geom_vline(xintercept = mm) +
  geom_vline(xintercept = mean(binary_metareg$cond_mean), linetype = "dashed") +
  stat_dist_halfeye(aes(dist = dist),
                    show.legend = FALSE,
                    .width = 0.95,
                    scale = 1) +
  theme(axis.ticks.x = element_blank()) +
  ylab("Study") +
  geom_label(aes(x = cond_mean, y = 7, label = note), 
             size = 6, label.size = NA) +
  theme(axis.text.x = element_blank()) +
  theme_rfig() +
  xlab(latex2exp::TeX("$y_i$")) +
  ggtitle("Categorical Predictor") +
  xlim(xlim) +
  annotate("text", x = 1, y = 1.5, 
           label = TeX("\\textbf{Residual $\\tau^2$}"), 
           parse = TRUE, color = "firebrick", 
           family = "bold", size = 8) +
  annotate("text", x = 1, y = 2, 
           label = TeX("\\textbf{Explained $\\tau^2$}"), 
           parse = TRUE, color = "darkgreen", 
           family = "bold", size = 8) +
  geom_point(aes(x = obs, y = id), color = "firebrick", shape = 15, size = 2.5)

# Metaregression with numerical predictor ---------------------------------

x <- seq(1, 6, 1)

cont_metareg <- data.frame(
  id = 1:6,
  yi = c(0.2656016, 0.5375599, 0.4202332, 0.3823055, 0.5343109, 0.9233668),
  vi = c(0.001, 0.002, 0.001, 0.001, 0.002, 0.003),
  x
)

cont_metareg <- arrange(cont_metareg, yi)

cont_metareg$dist <- map2(cont_metareg$yi, 
                          sqrt(cont_metareg$vi), 
                          dist_normal)

#cont_metareg$yi <- ifelse(cont_metareg$id == 5, cont_metareg$yi+0.1, cont_metareg$yi)

fit <- lm(yi ~ x, data = cont_metareg)
cont_metareg$pi <- predict(fit, newdata = data.frame(x = cont_metareg$x-0.1))
cont_metareg$gm <- mean(cont_metareg$yi)
cont_metareg$res <- cont_metareg$yi - cont_metareg$pi


set.seed(2027)
cont_metareg$obs <- rnorm(nrow(cont_metareg), cont_metareg$yi, sqrt(cont_metareg$vi))

plot_metareg_cont <- ggplot(cont_metareg, aes(x = x, y = yi)) +
  geom_segment(aes(x = x-0.1, xend = x-0.1, y = pi, yend = obs), color = "firebrick", linewidth = 1) +
  geom_segment(aes(x = x-0.1, xend = x-0.1, y = gm, yend = pi), color = "darkgreen", linewidth = 1) +
  geom_segment(data = filter(cont_metareg, obs < pi & obs > gm), aes(x = x-0.1, xend = x-0.1, y = gm, yend = pi), 
               color = "darkgreen", linewidth = 1) +
  geom_segment(data = filter(cont_metareg, obs < pi & obs > gm),
               aes(x = x-0.1, xend = x-0.1, y = pi, yend = obs), 
               color = "firebrick", linewidth = 1) +
  geom_hline(yintercept = mean(cont_metareg$yi), linetype = "dashed") +
  stat_halfeye(aes(dist = dist),
               show.legend = FALSE,
               color = "black",
               .width = 0.95,
               scale = 0.7) +
  geom_abline(intercept = fit$coefficients[1], slope = fit$coefficients[2]) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  theme_rfig() +
  ylab(latex2exp::TeX("$y_i$")) +
  ggtitle("Numerical Predictor") +
  annotate("text", x = 6.5, y = 0.25,
           label = TeX("\\textbf{Residual $\\tau^2$}"), 
           parse = TRUE, color = "firebrick", size = 8,
           family = "lmroman") +
  annotate("text", x = 6.5, y = 0.3, 
           label = TeX("\\textbf{Explained $\\tau^2$}"), 
           parse = TRUE, color = "darkgreen", size = 8,
           family = "lmroman") +
  geom_point(aes(x = x, y = obs), color = "firebrick", shape = 15, size = 2.5)

# Saving ------------------------------------------------------------------

r_imgs <- list(equal_vs_random = equal_vs_random,
               equal = p_equal, random = p_random,
               plot_metareg_bin = plot_metareg_bin,
               plot_metareg_cont = plot_metareg_cont)

saveRDS(r_imgs, here("04-meta-analysis", "slides", "objects", "r-imgs.rds"))