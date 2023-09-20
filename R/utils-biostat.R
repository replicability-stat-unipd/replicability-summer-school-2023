#' get_bio_data
#' @description
#' Return a standard dataframe from a gene-phenotype database.
#' @param data the database
#' @param gene a character vector with gene names
#' @param phenotype a character vector with phenotype variables
#'
#' @return a dataframe
#' @export
#'
get_bio_data <- function(data, gene = NULL, phenotype = NULL){
  gene <- if(is.null(gene)) get_gene_names(data) else gene
  phenotype <- if(is.null(phenotype)) get_pheno_names(data) else phenotype
  
  phend <- data.frame(Biobase::pData(data)[, phenotype])
  gened <- data.frame(Biobase::exprs(data)[gene, ])
  if(length(gene) != 1){
    gened <- data.frame(t(gened))
  }
  out <- cbind(phend, gened)
  colnames(out) <- c(phenotype, gene)
  rownames(out) <- NULL
  return(out)
}

has_pheno <- function(data, pheno){
    pheno %in% get_pheno_names(data)
}

has_gene <- function(data, gene){
    gene %in% get_gene_names(data)
}

#' sim_bin_class
#' @description
#' Simulate a binary classifier given the Area Under the Curve or the difference between
#' latent distribution (d) the total sample size and the prevalence of disease.
#' The disease is classified as 1. The predictor is simulated from a standard normal distribution.
#' The x.mean will be the average of the predictor regardless the class. The distance between the latent
#' distributions will be -d/2 for the control group and d/2 for the disease group. If AUC is specified
#' the value is converted to d before sampling from the latent distributions.
#' @param auc area under the curve. Default to \code{NULL}
#' @param d difference between latent distributions. Default to \code{NULL}
#' @param n total number of cases
#' @param prevalence disease prevalence
#' @param x.mean true mean of the predictor. Default to 0
#' @param x.sd true standard deviation of the predictor. Default to 1
#' @param var.names 
#'
#' @return
#' @export
#'
#' @examples
sim_bin_class <- function(auc = NULL,
                          d = NULL,
                          n, 
                          prevalence, 
                          x.mean = 0,
                          x.sd = 1,
                          var.names = c(x = "x", y = "y")){
  if(is.null(auc) & is.null(d)){
    stop("AUC or d need to be specified")
  }
  
  if(is.null(d)){
    d <- auc_to_d(auc)
  }
  
  n1 <- ceiling(n * prevalence)
  n0 <- n - n1
  y <- rep(c(0, 1), c(n0, n1))
  x <- ifelse(y == 1, rnorm(n1, (d/2)*x.sd + x.mean, 1), rnorm(n0, (-d/2)*x.sd + x.mean, 1))
  dat <- data.frame(y, x)
  names(dat) <- var.names[names(dat)]
  return(dat)
}

#' auc_to_d
#' @description
#' Convert from AUC to Cohen's d using the formula by Ruscio (2008) A probability-based measure of effect size: Robustness to base rates and other factors. Psychological Methods, 13(1), 19-30. doi:10.1037/1082-989x.13.1.19
#' 
#' @param auc the area under the curve
#'
#' @return the Cohen's d
#' @export
#'
auc_to_d <- function(auc){
    qnorm(auc) * sqrt(2)
}

#' d_to_auc
#' @description
#' Convert from a Cohen's d to AUC using the formula by Ruscio (2008) A probability-based measure of effect size: Robustness to base rates and other factors. Psychological Methods, 13(1), 19-30. doi:10.1037/1082-989x.13.1.19
#' @param d Cohen's d
#'
#' @return the AUC
#' @export
#'
d_to_auc <- function(d){
    pnorm(d / sqrt(2))
}

#' classify
#'
#' @param data a dataframe
#' @param y name of the response (binary) variable
#' @param x name of the numeric predictor
#' @param c vector of cutoffs
#' @param na.rm logical indicating whether NA should be removed or not. Default to \code{FALSE} 
#'
#' @return a dataframe with several classification metrics
#' @export
#'
classify <- function(data, y, x, c, na.rm = FALSE){
  xn <- deparse(substitute(x))
  yn <- deparse(substitute(y))
  
  if(na.rm){
    data <- data[complete.cases(data[, c(xn, yn)]), ]
  }
  
  confusion <- lapply(c, function(cr){
    # classify based on c
    yp <- ifelse(data[[xn]] >= cr, 1, 0)
    
    out <- data.frame(
      tp = sum(data[[yn]] == 1 & yp == 1),
      fp = sum(data[[yn]] == 0 & yp == 1),
      tn = sum(data[[yn]] == 0 & yp == 0),
      fn = sum(data[[yn]] == 1 & yp == 0)
    )
    
    # rates
    out$tpr <- with(out, tp / (tp + fn))
    out$fpr <- with(out, fp / (fp + tn))
    out$tnr <- 1 - out$fpr
    out$fnr <- 1 - out$tpr
    out$tot <- nrow(data)
    out$prevalence <- mean(data[[yn]] == 1)
    out$c <- cr
    out$ppv <- with(out, tp / (tp + fp))
    out$npv <- with(out, tn / (tn + fn))
    out
  })
  
  do.call(rbind, confusion)
}

#' plot_class
#' @description
#' Plot a binary classifier. Produce a density plot for each binary outcome and a dotplot with the estimated logistic curve.
#' 
#' @param data a dataframe
#' @param y the name of the response variable (need to be a numeric 0-1)
#' @param x the name of the numeric predictor
#'
#' @return the plots
#' @export
#'
plot_class <- function(data, y, x){
  
  x <- deparse(substitute(x))
  y <- deparse(substitute(y))
  
  if(!is.numeric(data[[y]])) stop("The response variable need to be numeric (0-1)")

  dens <- tapply(data[[x]], data[[y]], density)
  ndens <- names(dens)
  
  fit <- glm(data[[y]] ~ data[[x]], family = binomial(link = "logit"))
  def.par = par(no.readonly = TRUE)
  
  xlim <- c(min(sapply(dens, function(x) min(x$x))),
            max(sapply(dens, function(x) max(x$x))))
  
  ylim <- c(0, max(sapply(dens, function(x) max(x$y))))
  
  par(mfrow = c(1, 2))
  
  plot(dens[[1]],
       main = "Density Plot",
       xlab = x,
       col = "firebrick",
       lwd = 1.5,
       xlim = xlim,
       ylim = ylim)
  rug(data[[x]][data[[y]] == ndens[1]], col = "firebrick", lwd = 1.5)
  rug(data[[x]][data[[y]] == ndens[2]], col = "dodgerblue3", lwd = 1.5)
  lines(dens[[2]], col = "dodgerblue3", lwd = 1.5)
  
  xr <- seq(min(data[[x]]), max(data[[x]]), length.out = 500)
  
  pr <- plogis(coef(fit)[1] + coef(fit)[2]*xr)
  
  y_jitt <- jitter(data[[y]], 0.2)
  y_col <- ifelse(data[[y]] == ndens[1], "firebrick", "dodgerblue3")
  
  plot(data[[x]], y_jitt, 
       col = scales::alpha(y_col, 0.4),
       pch = 19,
       main = "Dotplot",
       xlab = x,
       ylab = y)
  lines(xr, pr)
  
  par(def.par)
}

#' getdata
#' 
#' @export
#'
getdata <- function(dataset, package){
  env <- new.env()
  lapply(dataset, function(x) data(list = x, package = package, envir = env))
  dlist <- lapply(dataset, function(x) base::get(x, envir = env))
  names(dlist) <- dataset
  if(length(dlist) == 1){
      dlist <- dlist[[1]]
  }
  return(dlist)
}

#' get_gene_names
#' 
#' @export
#' 
get_gene_names <- function(data){
  rownames(Biobase::exprs(data))
}

#' get_gene_names
#' 
#' @export
#' 
get_pheno_names <- function(data){
    rownames(data.frame(Biobase::phenoData(data)@varMetadata))
}

#' contingency_tab
#' @description
#' Create an HTML contingency table from a classification table created with the \code{classify()} function. Useful for teaching.
#' 
#' @param cmat a dataframe created with the \code{classify()} function
#' @param fontsize numeric value for the font size
#'
#' @return
#' @export
#' @example
#' sim_bin_class(0.8, n = 100, prevalence = 0.5) |> 
#'     classify(y, x, 0) |> 
#'     contingency_tab()
contingency_tab <- function(cmat, fontsize = 20){
  
  colors <- c(TP = "lightgreen", FP = "#FC8D8D",
              TN = "lightgreen", FN = "#FC8D8D",
              Tot = "white")
  
  template <- tibble::tibble(
    V1 = c("Test", "Test", "Test"),
    V2 = c(1, 0, "Tot"),
    V3 = c("TP" = cmat$tp, "FN" = cmat$fn, "Tot" = cmat$tp + cmat$fn),
    V4 = c("FP" = cmat$fp, "TN" = cmat$tn, "Tot" = cmat$fp + cmat$tn),
    V5 = c(cmat$tp + cmat$fp, cmat$fn + cmat$tn, cmat$tot)
  )
  
  annotation <- c(
    sprintf("<b>Threshold</b> = %s", cmat$c),
    sprintf("<b>Sensitivity</b> = %.3f", cmat$tpr),
    sprintf("<b>Specificity</b> = %.3f", cmat$tnr),
    sprintf("<b>PPV</b> = %.3f", (cmat$tp)/(cmat$tp + cmat$fp))
  )
  
  template$V3 <- kableExtra::cell_spec(template$V3, background = colors[names(template$V3)])
  template$V4 <- kableExtra::cell_spec(template$V4, background = colors[names(template$V4)])
  
  template |> 
    kableExtra::kable(col.names = c("", "", "1", "0", "Tot"),
          align = "c",
          escape = FALSE) |> 
    kableExtra::kable_styling(font_size = fontsize) |> 
    kableExtra::column_spec(1:2, bold = TRUE) |> 
    kableExtra:: collapse_rows(columns = 1) |> 
    kableExtra::footnote(general = annotation, escape = FALSE, general_title = "") |> 
    kableExtra::add_header_above(c(" " = 2, "Truth" = 3))
  
}

#' ppv
#' @description
#' Calculate the Positive Predictive Value
#' 
#' @param tp number of true positives
#' @param fp number of false positives
#' @param sensitivity specificity
#' @param specificity sensitivity
#' @param prevalence the prevalence (proportion)
#'
#' @return the PPV
#' @export
#'
ppv <- function(tp = NULL,
                fp = NULL, 
                sensitivity = NULL, 
                specificity = NULL, 
                prevalence = NULL){
  if(!is.null(tp) & !is.null(fp)){
    tp / (tp + fp)
  } else if(!is.null(sensitivity) & !is.null(specificity) & !is.null(prevalence)){
    (sensitivity * prevalence) / (sensitivity * prevalence + (1 - specificity) * (1 - prevalence))
  } else{
    stop("To calculate PPV tp AND fp OR sensitivity AND specificity AND prevalence need to be specified!")
  }
}

#' npv
#' @description
#' Calculate the Negative Predictive Value
#' 
#' @param tn number of true negatives
#' @param fn number of false negatives
#' @param sensitivity specificity
#' @param specificity sensitivity
#' @param prevalence the prevalence (proportion)
#'
#' @return the PPV
#' @export
#'
npv <- function(tn = NULL, 
                fn = NULL, 
                sensitivity = NULL, 
                specificity = NULL, 
                prevalence = NULL){
  if(!is.null(tn) & !is.null(fn)){
    tn / (tn + fn)
  } else if(!is.null(sensitivity) & !is.null(specificity) & !is.null(prevalence)){
    (specificity * (1 - prevalence)) / ((1 - sensitivity) * prevalence + specificity * (1 - prevalence))
  } else{
    stop("To calculate NPV tn AND fn OR sensitivity AND specificity AND prevalence need to be specified!")
  }
}

#' plot_gene_range
#' @export
plot_gene_range <- function(datal, gene){
  
  datal <- list(datal)
  
  datal <- lapply(datal, function(x) x[complete.cases(x[, c("debulking", gene)]), ])
  
  ddlist <- lapply(datal, function(x) tapply(x[[gene]], x$debulking, density, na.rm = TRUE))
  
  xmin <- min(sapply(ddlist, function(x) min(c(x$optimal$x, x$suboptimal$x))))
  xmax <- max(sapply(ddlist, function(x) max(c(x$optimal$x, x$suboptimal$x))))
  ymax <- max(sapply(ddlist, function(x) max(c(x$optimal$y, x$suboptimal$y))))
  
  plot(ddlist[[1]]$optimal,
       xlim = c(xmin, xmax), 
       ylim = c(0, ymax), 
       type = "n",
       xlab = gene,
       ylab = "Density",
       main = "")
  print(ddlist)
  
  if(length(datal) == 1){
    rug(datal[[1]][[gene]][datal[[1]]$debulking == "optimal"], col = "green")
    rug(datal[[1]][[gene]][datal[[1]]$debulking == "suboptimal"], col = "red")
  }
  
  legend("topleft",
         legend = c("Optimal", "Suboptimal"),
         fill = c("green", "red"))
  
  for(i in 1:length(ddlist)){
    lines(ddlist[[i]]$suboptimal, col = "red", lwd = 1.2)
    lines(ddlist[[i]]$optimal, col = "green", lwd = 1.2)
  }
}

ggROC <- function(data, size = 15, fill = FALSE){
    data |> 
        ggplot(aes(x = tnr, y = tpr)) +
        scale_x_reverse(limits = c(1, 0)) +
        ylim(c(0, 1)) +
        geom_abline(intercept = 1, color = "darkgrey") +
        geom_line(linewidth = 1) +
        coord_fixed() +
        theme_minimal(size) +
        xlab("Specificity") +
        ylab("Sensitivity") + {
            if(fill){
                geom_ribbon(aes(ymax = tpr, ymin = 1 - tnr),
                            alpha = 0.1,
                            fill = "firebrick")
            }
        }
}