#' get_project_packages
#' @export
#'
get_project_packages <- function(){
  pkgs <- renv::dependencies(quiet = TRUE)
  installed_pkgs <- as.data.frame(installed.packages()[, c(1, 3:4)])
  installed_pkgs <- installed_pkgs[is.na(installed_pkgs$Priority), ]
  df_pkgs <- installed_pkgs[installed_pkgs$Package %in% unique(pkgs$Package), ]
  df_pkgs <- df_pkgs[, 1:2]
  rownames(df_pkgs) <- NULL
  names(df_pkgs) <- c("package", "version")
  df_pkgs$repository <- NA
  
  for(i in 1:nrow(df_pkgs)){
    desc <- packageDescription(df_pkgs$package[i])
    desc <- 
      
      if(is.null( desc$Repository)){
        if(!is.null(desc$GithubRepo)){
          df_pkgs$repository[i] <- paste0(desc$GithubUsername, "/", desc$GithubRepo)
        }else{
          if(any(grepl("bioconductor", tolower(unlist(desc))))){
            df_pkgs$repository[i] <- "bioconductor"
          }else{
            df_pkgs$repository[i] <- "other"
          }
        }
      }else{
        df_pkgs$repository[i] <-  desc$Repository
      }
  }
  return(df_pkgs)
}

#' quiet
#' @param x 
#' @export
quiet <- function(x) {
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 

mkdir_if <- function(dir){
  if(!dir.exists(dir)) dir.create(dir)
}

is_same_md5 <- function(current, new){
  current == tools::md5sum(new)
}

.db_slides <- function(){
  mkdir_if(".md5_slides")
  files <- list.files(".", recursive = TRUE, pattern = "qmd")
  files <- files[!grepl("deprecated", files)]
  dfile <- tools::md5sum(files)
  saveRDS(dfile, ".md5_slides/dfile.rds")
}

qrender <- function(file){
    quarto::quarto_render(file, quiet = TRUE)
    cli::cli_alert_success(sprintf("File %s rendered!", cli::col_blue(file)))
}

getmd5 <- function(file){
  dfile <- readRDS(".md5_slides/dfile.rds")
  dfile[file]
}

updatemd5 <- function(file){
  dfile <- readRDS(".md5_slides/dfile.rds")
  newmd5 <- tools::md5sum(file)
  dfile[file] <- newmd5
  saveRDS(dfile, ".md5_slides/dfile.rds")
}

render_all <- function(dir = ".", exclude = NULL, force = FALSE){
  all_files <- list.files(path = dir, recursive = TRUE, pattern = "qmd", full.names = TRUE)
  all_files <- all_files[!grepl("deprecated|_site", all_files)]
  all_files <- gsub("\\./", "", all_files)
  if(!is.null(exclude)){
      exclude <- paste0(exclude, collapse = "|")
      all_files <- all_files[!grepl(exclude, all_files)]
  }
  
  dfile <- readRDS(".md5_slides/dfile.rds")
  for(i in 1:length(all_files)){
    if(!force){
      if(!is_same_md5(dfile[all_files[i]], all_files[i])){
        qrender(all_files[i])
        updatemd5(all_files[i])
      }else{
        cli::cli_alert_info(paste("file", cli::col_blue(all_files[i]), "did not change!"))
      }
    }else{
      qrender(all_files[i])
      updatemd5(all_files[i])
    }
  }
}

#' Render Table of Contents
#' 
#' A simple function to extract headers from an RMarkdown or Markdown document
#' and build a table of contents. Returns a markdown list with links to the 
#' headers using 
#' [pandoc header identifiers](http://pandoc.org/MANUAL.html#header-identifiers).
#' 
#' WARNING: This function only works with hash-tag headers.
#' 
#' Because this function returns only the markdown list, the header for the
#' Table of Contents itself must be manually included in the text. Use
#' `toc_header_name` to exclude the table of contents header from the TOC, or
#' set to `NULL` for it to be included.
#' 
#' @section Usage:
#' Just drop in a chunk where you want the toc to appear (set `echo=FALSE`):
#' 
#'     # Table of Contents
#' 
#'     ```{r echo=FALSE}
#'     render_toc("/path/to/the/file.Rmd")
#'     ```
#' 
#' @param filename Name of RMarkdown or Markdown document
#' @param toc_header_name The table of contents header name. If specified, any
#'   header with this format will not be included in the TOC. Set to `NULL` to
#'   include the TOC itself in the TOC (but why?).
#' @param base_level Starting level of the lowest header level. Any headers 
#'   prior to the first header at the base_level are dropped silently.
#' @param toc_depth Maximum depth for TOC, relative to base_level. Default is
#'   `toc_depth = 3`, which results in a TOC of at most 3 levels.
render_toc <- function(
        filename, 
        toc_header_name = "Table of Contents",
        base_level = NULL,
        toc_depth = 3
) {
    x <- readLines(filename, warn = FALSE)
    x <- paste(x, collapse = "\n")
    x <- paste0("\n", x, "\n")
    for (i in 5:3) {
        regex_code_fence <- paste0("\n[`]{", i, "}.+?[`]{", i, "}\n")
        x <- gsub(regex_code_fence, "", x)
    }
    x <- strsplit(x, "\n")[[1]]
    x <- x[grepl("^#+", x)]
    if (!is.null(toc_header_name)) 
        x <- x[!grepl(paste0("^#+ ", toc_header_name), x)]
    if (is.null(base_level))
        base_level <- min(sapply(gsub("(#+).+", "\\1", x), nchar))
    start_at_base_level <- FALSE
    x <- sapply(x, function(h) {
        level <- nchar(gsub("(#+).+", "\\1", h)) - base_level
        if (level < 0) {
            stop("Cannot have negative header levels. Problematic header \"", h, '" ',
                 "was considered level ", level, ". Please adjust `base_level`.")
        }
        if (level > toc_depth - 1) return("")
        if (!start_at_base_level && level == 0) start_at_base_level <<- TRUE
        if (!start_at_base_level) return("")
        if (grepl("\\{#.+\\}(\\s+)?$", h)) {
            # has special header slug
            header_text <- gsub("#+ (.+)\\s+?\\{.+$", "\\1", h)
            header_slug <- gsub(".+\\{\\s?#([-_.a-zA-Z]+).+", "\\1", h)
        } else {
            header_text <- gsub("#+\\s+?", "", h)
            header_text <- gsub("\\s+?\\{.+\\}\\s*$", "", header_text) # strip { .tabset ... }
            header_text <- gsub("^[^[:alpha:]]*\\s*", "", header_text) # remove up to first alpha char
            header_slug <- paste(strsplit(header_text, " ")[[1]], collapse="-")
            header_slug <- tolower(header_slug)
        }
        paste0(strrep(" ", level * 4), "- [", header_text, "](#", header_slug, ")")
    })
    x <- x[x != ""]
    knitr::asis_output(paste(x, collapse = "\n"))
}

link_refs <- function(){
  file <- xfun::embed_file("refs_to_download.bib", text = " Download .bib file")
  sprintf('<button class="btn"><i class="fa fa-download"></i>%s</button>', file)
}

#' quiet(function(x))
#' Suppresses output messages
#' By Hadley Wickham
#' http://r.789695.n4.nabble.com/Suppressing-output-e-g-from-cat-td859876.html
#'
#' @export

quiet <- function(x) {
    sink(tempfile())
    on.exit(sink())
    invisible(force(x))
}