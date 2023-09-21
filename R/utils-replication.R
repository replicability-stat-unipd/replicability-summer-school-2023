theta_from_z <- function(z, n){
  sqrt(4/(n * 2)) * z
}

#' bf_replication
#'
#' @param mu_original 
#' @param se_original 
#' @param replication 
#'
#' @export
#'
bf_replication <- function(mu_original,
                           se_original,
                           replication){
  
  # prior based on the original study
  prior <- rstanarm::normal(location = mu_original, scale = se_original)
  
  # to dataframe
  replication <- data.frame(y = replication)
  
  fit <- rstanarm::stan_glm(y ~ 1,
                            data = replication,
                            prior_intercept = prior, 
                            refresh = 0) # avoid printing
  
  bf <- bayestestR::bayesfactor_pointnull(fit, null = 0, verbose = FALSE)
  
  title <- "Bayes Factor Replication Rate"
  posterior <- "Posterior Distribution ~ Mean: %.3f, SE: %.3f"
  replication <- "Evidence for replication: %3f (log %.3f)"
  non_replication <- "Evidence for non replication: %3f (log %.3f)"
  
  if(bf$log_BF > 0){
    replication <- cli::col_green(sprintf(replication, exp(bf$log_BF), bf$log_BF))
    non_replication <- sprintf(non_replication, 1/exp(bf$log_BF), -bf$log_BF)
  }else{
    replication <- sprintf(replication, exp(bf$log_BF), bf$log_BF)
    non_replication <- cli::col_red(sprintf(non_replication, 1/exp(bf$log_BF), -bf$log_BF))
  }
  
  outlist <- list(
    fit = fit,
    bf = bf
  )
  
  cat(
    cli::col_blue(title),
    cli::rule(),
    sprintf(posterior, fit$coefficients, fit$ses),
    "\n",
    replication,
    non_replication,
    sep = "\n"
  )
  
  invisible(outlist)
  
}

Qrep <- function(yi, vi, lambda0 = 0, alpha = 0.05){
  fit <- metafor::rma(yi, vi)
  k <- fit$k
  Q <- fit$QE
  df <- k - 1
  Qp <- pchisq(Q, df = df, ncp = lambda0, lower.tail = FALSE)
  pval <- ifelse(Qp < 0.001, "p < 0.001", sprintf("p = %.3f", Qp))
  lambda <- ifelse((Q - df) < 0, 0, (Q - df))
  res <- list(Q = Q, lambda = lambda, pval = Qp, df = df, k = k, alpha = alpha, lambda0 = lambda0)
  H0 <- ifelse(lambda0 != 0, paste("H0: lambda <", lambda0), "H0: lambda = 0")
  title <- ifelse(lambda0 != 0, "Q test for Approximate Replication", "Q test for Exact Replication")
  cli::cli_rule()
  cat(cli::col_blue(cli::style_bold(title)), "\n\n")
  cat(sprintf("Q = %.3f (df = %s), lambda = %.3f, %s", res$Q, res$df, lambda, pval), "\n")
  cat(H0, "\n")
  cli::cli_rule()
  class(res) <- "Qrep"
  invisible(res)
}

plot.Qrep <- function(obj){
  title <- ifelse(obj$lambda0 != 0, "Q test for Approximate Replication", "Q test for Exact Replication")
  xlim <- c(0, max(c(obj$Q, obj$k - 1)))
  
  curve(dchisq(x, obj$k - 1, obj$lambda0), xlim[1], xlim[2] + xlim[2]/2, xlab = "Q", ylab = "Density", lwd = 2, main = title)
  Qc <- qchisq(1 - obj$alpha, obj$k - 1, obj$lambda0)
  points(obj$Q, 0, col = "dodgerblue", pch = 19, cex = 1.5)
  abline(v = Qc, col = "firebrick", lwd = 2)
}

#' telescope_plot
#'
#' @param tdata 
#' @export
telescope_plot <- function(tdata){
  ggplot(tdata, aes(x = id, y = d)) +
    geom_pointrange(aes(ymin = lower, ymax = upper)) +
    geom_hline(aes(yintercept = small),
               linetype = "dashed",
               color = "firebrick") +
    annotate("label", x = 1.5, y = mean(tdata$d),
             label = sprintf("Small effect = %.3f", tdata$small[1])) +
    theme_minimal(base_size = 15) +
    theme(axis.title.x = element_blank())
}

#' small_telescope
#'
#' @param or_d 
#' @param or_se 
#' @param rep_d 
#' @param rep_se 
#' @param small 
#' @param ci 
#'
#' @export
#'
small_telescope <- function(or_d,
                            or_se,
                            rep_d,
                            rep_se,
                            small,
                            ci = 0.95){
  # quantile for the ci
  qs <- c((1 - ci)/2, 1 - (1 - ci)/2)
  
  # original confidence interval
  or_ci <- or_d + qnorm(qs) * or_se
  
  # replication confidence interval
  rep_ci <- rep_d + qnorm(qs) * rep_se
  
  # small power
  is_replicated <- rep_ci[2] > small
  
  msg_original <- sprintf("Original Study: d = %.3f %s CI = [%.3f, %.3f]",
                          or_d, ci, or_ci[1], or_ci[2])
  
  msg_replicated <- sprintf("Replication Study: d = %.3f %s CI = [%.3f, %.3f]",
                            rep_d, ci, rep_ci[1], rep_ci[2])
  
  
  if(is_replicated){
    msg_res <- sprintf("The replicated effect is not smaller than the small effect (%.3f), (probably) replication!", small)
    msg_res <- cli::col_green(msg_res)
  }else{
    msg_res <- sprintf("The replicated effect is smaller than the small effect (%.3f), no replication!", small)
    msg_res <- cli::col_red(msg_res)
  }
  
  out <- data.frame(id = c("original", "replication"),
                    d = c(or_d, rep_d),
                    lower = c(or_ci[1], rep_ci[1]),
                    upper = c(or_ci[2], rep_ci[2]),
                    small = small
  )
  
  # nice message
  cat(
    msg_original,
    msg_replicated,
    cli::rule(),
    msg_res,
    sep = "\n"
  )
  
  invisible(out)
  
}