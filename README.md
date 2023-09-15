
# Contents

- [Contents](#contents)
- [Information](#information)
- [Getting started](#getting-started)
  - [Installing R and R Studio
    `#important`](#installing-r-and-r-studio-%60#important%60)
    - [Installing R binaries
      `#important`](#installing-r-binaries-%60#important%60)
    - [R Studio `#important`](#r-studio-%60#important%60)
  - [Quarto `#important`](#quarto-%60#important%60)
  - [GIT](#git)
  - [Accounts](#accounts)
    - [Github](#github)
    - [Open Science Framework](#open-science-framework)
  - [R Packages `#important`](#r-packages-%60#important%60)
    - [CRAN Packages `#important`](#cran-packages-%60#important%60)
    - [Github Packages `#important`](#github-packages-%60#important%60)
    - [Bioconductor Packages
      `#important`](#bioconductor-packages-%60#important%60)
- [All packages](#all-packages)
- [Repository](#repository)
  - [Functions](#functions)
  - [Useful links](#useful-links)
- [Materials](#materials)
  - [Slides](#slides)
  - [Data](#data)

# Information

This page contains the materials (slide, code, extra) used during the
Summer School. For general information and official communications see
the page
[replicability.stat.unipd.it](https://replicability.stat.unipd.it/).
This website is the web version of the bare Github repository that can
be accessed here
[github.com/replicability-stat-unipd/replicability-summer-school-2023](https://github.com/replicability-stat-unipd/replicability-summer-school-2023)
or by pressing the `View on Github` button.

# Getting started

In this section are listed the software and packages required by the
Summer School workshops. The elements marked with `#important` are
necessary for the workshops. Other elements will be covered by during
the workshops but are less relevant for the practical activities.

## Installing R and R Studio `#important`

### Installing R binaries `#important`

The first step is installing R that is a very straightforward process.
You can go to <https://cran.r-project.org/>, download the installer for
your operating system and follow the steps.

#### Additionals tools `#important`

For MAC users there is an additional tool that is required called
`XQuartz` <https://www.xquartz.org/>.

For Windows users, `Rtools`
<https://cran.r-project.org/bin/windows/Rtools/> is an additional tool
required by some packages to works correctly. Remember to choose the
version corresponding to the R version that you installed.

### R Studio `#important`

R Studio (now Posit) is an IDE to use the R programming language but
also other programming languages. Is not the only option to use R (for
hardcore users you can basically open a text editor and a terminal
:skull:). Another very good option is VScode (which I personally use
when writing using Quarto or R Markdown). However, I suggest you to
install R Studio, you can download the last version from the website
<https://posit.co/products/open-source/rstudio/>

## Quarto `#important`

Quarto is the evolution of R Markdown. Is a literate programming
framework where prose (written in Markdown) can be combined with code
(R, Python, Julia, etc.). This is an amazing tool to create report,
presentations, papers etc. you can download it from
<https://quarto.org/>.

## GIT

> Git is a free and open source distributed version control system
> designed to handle everything from small to very large projects with
> peed and efficiency.

Git is an extremely powerful tool to manage code-related projects (but
not only). You can download it from the website <https://git-scm.com/>.

## Accounts

### Github

Github is the online server where Git repositories can be hosted. It is
an amazing service where you can also create websites for free (where
this page is hosted) just using R and Quarto (or R Markdown). You can
create an account on the website <https://github.com/>.

To use Github and Git from the command line you can use `ssh` (to avoid
typing the password for each operation). You can follow this guide
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?tool=webui&platform=linux>.

### Open Science Framework

The Open Science Framework (OSF) is an free online repository to host
documents, code and files related to research work. The repository can
be shared and OSF will attach a DOI thus can be cited and shared in a
consistent way. OSF can be linked to several other services such as
reference managers, cloud storage and Github. You can create an account
on the website <https://osf.io/>.

## R Packages `#important`

Beyond the base R installation we need extra packages for the workshops.
In any case, R Studio will prompt you to install missing packages when
detected from a script.

### CRAN Packages `#important`

To install packages from CRAN you can run the following code into the R
console:

``` r
pkgs <- c("tidyverse", "car", "devtools", "here", "knitr", "rmarkdown", "metafor", "MetaUtility", "pROC", "Replicate", "rstanarm", "sjPlot", "remotes", "cli", "logspline", "pwr", "ggdist")

install.packages(pkgs)
```

### Github Packages `#important`

There are some packages that are not available on CRAN. You can install
using the following code:

``` r
if (!require("remotes", quietly = TRUE)) install.packages("remotes")
gh_pkgs <- c("haozhu233/kableExtra", "filippogambarota/filor")
remotes::install_github(gh_pkgs)
```

### Bioconductor Packages `#important`

There are some packages from the `Bioconductor` repository. You can
install using the following code.

``` r
if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install("curatedOvarianData")
```

# All packages

The packages indicated in the section above are the essential packages
for the workshops. To reproduce the slides, plots and the overall
project (not required to follow the workshops) there are extra packages.
You can avoid installing it but this is a complete list:

| package            | version    | repository             |
|:-------------------|:-----------|:-----------------------|
| bayestestR         | 0.13.1     | CRAN                   |
| bib2df             | 1.1.1      | CRAN                   |
| Biobase            | 2.60.0     | bioconductor           |
| broom              | 1.0.5      | CRAN                   |
| car                | 3.1-2      | CRAN                   |
| cli                | 3.6.1      | CRAN                   |
| cowplot            | 1.1.1      | CRAN                   |
| curatedOvarianData | 1.38.0     | bioconductor           |
| devtools           | 2.4.5      | CRAN                   |
| distributional     | 0.3.2      | CRAN                   |
| dplyr              | 1.1.2      | CRAN                   |
| DT                 | 0.28       | CRAN                   |
| emo                | 0.0.0.9000 | hadley/emo             |
| fansi              | 1.0.4      | CRAN                   |
| filor              | 0.1.0      | filippogambarota/filor |
| gganimate          | 1.0.8.9000 | thomasp85/gganimate    |
| ggdist             | 3.3.0      | CRAN                   |
| ggplot2            | 3.4.2      | CRAN                   |
| here               | 1.0.1      | CRAN                   |
| icons              | 0.2.0      | ropenscilabs/icon      |
| kableExtra         | 1.3.4.9000 | haozhu233/kableExtra   |
| knitr              | 1.43       | CRAN                   |
| latex2exp          | 0.9.6      | CRAN                   |
| lsr                | 0.5.2      | CRAN                   |
| ltxplot            | 1.0.0      | alicewchen/ltxplot     |
| magrittr           | 2.0.3      | CRAN                   |
| metafor            | 4.2-0      | CRAN                   |
| MetaUtility        | 2.1.2      | CRAN                   |
| pROC               | 1.18.4     | CRAN                   |
| purrr              | 1.0.2      | CRAN                   |
| pwr                | 1.3-0      | CRAN                   |
| quarto             | 1.2        | CRAN                   |
| readxl             | 1.4.3      | CRAN                   |
| RefManageR         | 1.4.0      | CRAN                   |
| renv               | 1.0.1      | CRAN                   |
| Replicate          | 1.2.0      | CRAN                   |
| rmarkdown          | 2.23       | CRAN                   |
| rstanarm           | 2.21.4     | CRAN                   |
| scales             | 1.2.1      | CRAN                   |
| shiny              | 1.7.4.1    | CRAN                   |
| sjPlot             | 2.8.14     | CRAN                   |
| tibble             | 3.2.1      | CRAN                   |
| tidyr              | 1.3.0      | CRAN                   |
| tidyverse          | 2.0.0      | CRAN                   |
| xfun               | 0.40       | CRAN                   |

# Repository

All the workshops materials are hosted in this repository. Once
everything is installed, you can start working with the repository. I
suggest you to download the entire folder. You can press the download
button (see the image below).

<center>
<img src="files/github-download.png" style="width:60.0%" />
</center>

If you want to use the `git` command-line (instead of manually
downloading) you can use the following command with a terminal opened on
the folder where you want the repository:

``` bash
git clone git@github.com:replicability-stat-unipd/replicability-summer-school-2023.git
```

Once downloaded, the project can be opened with `R Studio` simply
opening the `replicability-summer-school-2023.Rproj` file.

The repository is organized as an R package, and the
`devtools::load_all()` command mimic the `library()` behavior. In this
way all the functions, data, etc. will be available in the R
environment.

## Functions

Within slides and exercises we use some custom functions developed for
the workshop. These functions can be loaded with `devtools::load_all()`:

- `R/utils.R`: general utilities for managing the project (not useful
  for the workshop)
- `R/utils-meta.R`: utilities for the meta-analysis workshop
- `R/utils-biostat.R`: utilities for the biostatistic workshop
- `R/utils-replication.R`: utilities for the replication methods
  workshop

Relevant functions are documented. You can see the documentation
directly within the `R` files or using the standard syntax `?function`
after using `devtools::load_all()` (for functions where the
documentation is available).

## Useful links

- [Shared code
  editor](https://etherpad.wikimedia.org/p/replicability-summer-school-2023):
  the shared online notepad to write code together.

# Materials

## Slides

The slides are located into the specific folders. Then when relevant
`script/` and `objects/` folders contains extra documents and files used
in the slides and for exercises. You can directly open the slides
clicking on `html` or accessing the source code with `qmd`.

| Day        | Title                                               | Slides                                                            | Source                                                           |
|:-----------|:----------------------------------------------------|:------------------------------------------------------------------|:-----------------------------------------------------------------|
| 09-18-2023 | **Introduction to the workshops**                   | [html](00-intro/slides/00-intro.html)                             | [qmd](00-intro/slides/00-intro.qmd)                              |
| 09-18-2023 | **Tools for reproducible research**                 | [html](01-replication-tools/slides/01-replication-tools.html)     | [qmd](01-replication-tools/slides/01-replication-tools.qmd)      |
| 09-19-2023 | **Meta-Analysis and Multi-Lab Replication studies** | [html](02-meta-analysis/slides/02-meta-analysis.html)             | [qmd](02-meta-analysis/slides/02-meta-analysis.qmd)              |
| 09-20-2023 | **Exploring Replicability in Biostatistics**        | [html](03-biostatistics/slides/03-biostatistics.html)             | [qmd](03-biostatistics/slides/03-biostatistics.qmd)              |
| 09-21-2023 | **Statistical Methods for Replication Assessment**  | [html](04-replication-methods/slides/04-replication-methods.html) | [qmd](04-replication-methods/slides/04-replication-methods.html) |

## Data

The dataset used in the slides and for exercises are contained into the
specific workshop folder (e.g., `02-meta-analysis/objects/`) and into
the `data/` folder. To load a dataset you can manually import using
`readRDS()` or using the `data()` function after loading the package
with `devtools::load_all()`. For example:

``` r
dat <- readRDS("02-meta-analysis/objects/dear2019.rds")
devtools::load_all()
#> ℹ Loading ReprSummerSchool2023
data("dear2019")
ls()
#> [1] "dat"      "dear2019"
```

# Teamwork

For the teamwork you can find the papers in the table below. You can
download the entire folder (`papers/pdfs`) from the following
[link](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/replicability-stat-unipd/replicability-summer-school-2023/tree/master/papers).

| Authors                                                               | Title                                                                                                           | File                                                                                                                                                                                                  |
|:----------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Amrhein, Trafimow, and Greenland (2019)                               | Inferential Statistics as Descriptive Statistics: There Is No Replication Crisis if We Don’t Expect Replication | [pdf](papers/pdfs/Amrhein%20et%20al.%202019%20-%20Inferential%20Statistics%20as%20Descriptive%20Statistics%20-%20There%20Is%20No%20Replication%20Crisis%20if%20We%20Don’t%20Expect%20Replication.pdf) |
| Benjamini (2020)                                                      | Selective inference: The silent killer of replicability                                                         | [pdf](papers/pdfs/Benjamini%202020%20-%20Selective%20inference%20-%20The%20silent%20killer%20of%20replicability.pdf)                                                                                  |
| Errington, Mathur, Soderberg, Denis, Perfito, Iorns, and Nosek (2021) | Investigating the replicability of preclinical cancer biology                                                   | [pdf](papers/pdfs/Errington%20et%20al.%202021%20-%20Investigating%20the%20replicability%20of%20preclinical%20cancer%20biology.pdf)                                                                    |
| Franklin and Howson (1984)                                            | Why do scientists prefer to vary their experiments?                                                             | [pdf](papers/pdfs/Franklin%20and%20Howson%201984%20-%20Why%20do%20scientists%20prefer%20to%20vary%20their%20experiments.pdf)                                                                          |
| Jaljuli, Benjamini, Shenhav, Panagiotou, and Heller (2023)            | Quantifying Replicability and Consistency in Systematic Reviews                                                 | [pdf](papers/pdfs/Jaljuli%20et%20al.%202023%20-%20Quantifying%20Replicability%20and%20Consistency%20in%20Systematic%20Reviews.pdf)                                                                    |
| Ly, Etz, Marsman, and Wagenmakers (2019)                              | Replication Bayes factors from evidence updating                                                                | [pdf](papers/pdfs/Ly%20et%20al.%202019%20-%20Replication%20Bayes%20factors%20from%20evidence%20updating.pdf)                                                                                          |
| Patil and Parmigiani (2018)                                           | Training replicable predictors in multiple studies                                                              | [pdf](papers/pdfs/Patil%20and%20Parmigiani%202018%20-%20Training%20replicable%20predictors%20in%20multiple%20studies.pdf)                                                                             |
| Steegen, Tuerlinckx, Gelman, and Vanpaemel (2016)                     | Increasing Transparency Through a Multiverse Analysis                                                           | [pdf](papers/pdfs/Steegen%20et%20al.%202016%20-%20Increasing%20Transparency%20Through%20a%20Multiverse%20Analysis.pdf)                                                                                |
| Yang, Youyou, and Uzzi (2020)                                         | Estimating the deep replicability of scientific findings using human and artificial intelligence                | [pdf](papers/pdfs/Yang%20et%20al.%202020%20-%20Estimating%20the%20deep%20replicability%20of%20scientific%20findings%20using%20human%20and%20artificial%20intelligence.pdf)                            |
| Zondervan-Zwijnenburg, Van de Schoot, and Hoijtink (2022)             | Testing ANOVA Replications by Means of the Prior Predictive p-Value                                             | [pdf](papers/pdfs/Zondervan-Zwijnenburg%20et%20al.%202022%20-%20Testing%20ANOVA%20Replications%20by%20Means%20of%20the%20Prior%20Predictive%20p-Value.pdf)                                            |
