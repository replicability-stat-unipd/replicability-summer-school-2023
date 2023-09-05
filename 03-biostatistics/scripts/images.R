library(ggplot2)
library(gganimate)

dat <- sim_bin_class(0.8, n = 100, prevalence = 0.5)

cr <- seq(-3, 3, 0.1)
cmat <- classify(dat, y, x, cr)

cmat <- cmat[sample(1:nrow(cmat), nrow(cmat)),]

cmat$cs <- sprintf("%s%.2f", ifelse(sign(cmat$c) == -1, "-", "+"), abs(cmat$c))

p <- cmat |> 
  ggplot(aes(x = tnr, y = tpr)) +
  geom_point(size = 4,
             color = "firebrick") +
  geom_label(aes(x = 0.8, y = 1, label = paste("Threshold = ", cs)),
             size = 2) +
  scale_x_reverse() +
  xlab("Specificity") +
  ylab("Sensitivity") +
  theme_minimal(base_size = 10) +
  gganimate::transition_time(c) +
  gganimate::shadow_mark(alpha = 0.1)

p_anim <- gganimate::animate(p, 
                   device = "png",
                   width = 1000,
                   height = 1000,
                   res = 300,
                   fps = 5)

gganimate::anim_save("03-biostatistics/img/roc-anim.gif", p_anim)

