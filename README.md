
## Information

This page contains the materials (slide, code, extra) used during the
Summer School. For general information and official communications see
the page
[replicability.stat.unipd.it](https://replicability.stat.unipd.it/)

## General

The document
[getting-started](extra/getting-started/getting-started.html) contains a
tutorial to install all relevant packages for R and other tools. The
entire folder can be downloaded from
[here](https://github.com/replicability-stat-unipd/replicability-summer-school-2023/archive/refs/heads/main.zip)
or can be cloned using `git`.

``` bash
git clone git@github.com:replicability-stat-unipd/replicability-summer-school-2023.git
```

Once downloaded, the project can be opened with `R Studio` simply
opening the `replicability-summer-school-2023.Rproj` file. Then using
the command `devtools::load_all()` all the custom functions within the
`R/` folder can be used.

## Functions

Within slides and exercises we use some custom functions developed for
the workshop. These functions can be loaded with `devtools::load_all()`:

- `R/utils.R`: general utilities for managing the project (not useful
  for the workshop)
- `R/utils-meta.R`: utilities for the meta-analysis workshop
- `R/utils-biostat.R`: utilities for the biostatistic workshop
- `R/utils-replication.R`: utilities for the replication methods
  workshop

## Useful links

- [Shared code
  editor](https://etherpad.wikimedia.org/p/replicability-summer-school-2023)
- [Github
  repository](https://github.com/replicability-stat-unipd/replicability-summer-school-2023)

## Slides

The slides are located into the specific folders. Then when relevant
`script/` and `objects/` folders contains extra documents and files
included in the slides. The dataset used in the slides are contained
also into the `data` folder and datasets can be accessed also using the
`data()` function.

|    Day     |                        Title                        |                              Slides                               |                              Source                              |
|:----------:|:---------------------------------------------------:|:-----------------------------------------------------------------:|:----------------------------------------------------------------:|
| 09-18-2023 |          **Introduction to the workshops**          |               [html](00-intro/slides/00-intro.html)               |               [qmd](00-intro/slides/00-intro.qmd)                |
| 09-18-2023 |         **Tools for reproducible research**         |   [html](01-replication-tools/slides/01-replication-tools.html)   |   [qmd](01-replication-tools/slides/01-replication-tools.qmd)    |
| 09-19-2023 | **Meta-Analysis and Multi-Lab Replication studies** |       [html](02-meta-analysis/slides/02-meta-analysis.html)       |       [qmd](02-meta-analysis/slides/02-meta-analysis.qmd)        |
| 09-20-2023 |    **Exploring Replicability in Biostatistics**     |       [html](03-biostatistics/slides/03-biostatistics.html)       |       [qmd](03-biostatistics/slides/03-biostatistics.qmd)        |
| 09-21-2023 | **Statistical Methods for Replication Assessment**  | [html](04-replication-methods/slides/04-replication-methods.html) | [qmd](04-replication-methods/slides/04-replication-methods.html) |

## Teamwork

For the teamwork you can find the papers in the table below. You can
download the entire folder (`papers/pdfs`) from the following
[link](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/replicability-stat-unipd/replicability-summer-school-2023/tree/master/papers).

| Authors                                                               | Title                                                                                                                             | File                                                                                                                                                                                                     |
|:----------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Bertoldo, Zandonella Callegher, and Altoè (2022)                      | Concerns about replicability, theorizing, applicability, generalizability, and methodology across two crises in social psychology | [pdf](papers/pdfs/Bertoldo%20et%20al.%202022%20-%20Designing%20studies%20and%20evaluating%20research%20results%20-%20Type%20M%20and%20Type%20S%20errors%20for%20Pearson%20correlation%20coefficient.pdf) |
| Chambers and Tzavella (2022)                                          | Designing studies and evaluating research results: Type M and Type S errors for Pearson correlation coefficient                   | [pdf](papers/pdfs/Chambers%20and%20Tzavella%202022%20-%20The%20past,%20present%20and%20future%20of%20Registered%20Reports.pdf)                                                                           |
| Errington, Mathur, Soderberg, Denis, Perfito, Iorns, and Nosek (2021) | The past, present and future of Registered Reports                                                                                | [pdf](papers/pdfs/Errington%20et%20al.%202021%20-%20Investigating%20the%20replicability%20of%20preclinical%20cancer%20biology.pdf)                                                                       |
| Hedges and Schauer (2021)                                             | Testing ANOVA Replications by Means of the Prior Predictive p-Value                                                               | [pdf](papers/pdfs/Hedges%20and%20Schauer%202021%20-%20The%20Design%20of%20Replication%20Studies.pdf)                                                                                                     |
| Lakens (2023)                                                         | The Design of Replication Studies                                                                                                 | [pdf](papers/pdfs/Lakens%202023%20-%20Concerns%20about%20replicability,%20theorizing,%20applicability,%20generalizability,%20and%20methodology%20across%20two%20crises%20in%20social%20psychology.pdf)   |
| Patil and Parmigiani (2018)                                           | Replicability and Meta-Analysis                                                                                                   | [pdf](papers/pdfs/Patil%20and%20Parmigiani%202018%20-%20Training%20replicable%20predictors%20in%20multiple%20studies.pdf)                                                                                |
| Schauer (2022)                                                        | Training replicable predictors in multiple studies                                                                                | [pdf](papers/pdfs/Schauer%202022%20-%20Replicability%20and%20Meta-Analysis.pdf)                                                                                                                          |
| Steegen, Tuerlinckx, Gelman, and Vanpaemel (2016)                     | Investigating the replicability of preclinical cancer biology                                                                     | [pdf](papers/pdfs/Steegen%20et%20al.%202016%20-%20Increasing%20Transparency%20Through%20a%20Multiverse%20Analysis.pdf)                                                                                   |
| Zondervan-Zwijnenburg, Van de Schoot, and Hoijtink (2022)             | Increasing Transparency Through a Multiverse Analysis                                                                             | [pdf](papers/pdfs/Zondervan-Zwijnenburg%20et%20al.%202022%20-%20Testing%20ANOVA%20Replications%20by%20Means%20of%20the%20Prior%20Predictive%20p-Value.pdf)                                               |
