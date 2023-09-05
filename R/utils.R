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

render_all <- function(dir = ".", force = FALSE){
  all_files <- list.files(path = dir, recursive = TRUE, pattern = "qmd", full.names = TRUE)
  all_files <- all_files[!grepl("deprecated|_site", all_files)]
  all_files <- gsub("\\./", "", all_files)
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
    }
  }
}