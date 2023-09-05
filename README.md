## Information

This page contains the materials (slide, code, extra) used during the Summer School. For general information and official communications see the page [replicability.stat.unipd.it](https://replicability.stat.unipd.it/)

## General

The document [getting-started](docs/getting-started/getting-started.html) contains a tutorial to install all relevant packages for R and other tools. The entire folder can be downloaded from [here](https://github.com/replicability-stat-unipd/replicability-summer-school-2023/archive/refs/heads/main.zip) or can be cloned using `git`.

```bash
git clone git@github.com:replicability-stat-unipd/replicability-summer-school-2023.git
```

Once downloaded, the project can be opened with `R Studio` simply opening the `replicability-summer-school-2023.Rproj` file. Then using the command `devtools::load_all()` all the custom functions within the `R/` folder can be used.

## Functions

Within slides and exercises we use some custom functions developed for the workshop. These functions can be loaded with `devtools::load_all()`:

- `R/utils.R`: general utilities for managing the project (not useful for the workshop)
- `R/utils-meta.R`: utilities for the meta-analysis workshop
- `R/utils-biostat.R`: utilities for the biostatistic workshop
- `R/utils-replication.R`: utilities for the replication methods workshop

## Useful links

- [Shared code editor](https://etherpad.wikimedia.org/p/replicability-summer-school-2023)
- [Github repository](https://github.com/replicability-stat-unipd/replicability-summer-school-2023)

## Slides

The slides are located into the specific folders. Then when relevant `script/` and `objects/` folders contains extra documents and files included in the slides. The dataset used in the slides are contained also into the `data` folder and datasets can be accessed also using the `data()` function.

- **Introduction to the workshops** - 09-18-2023 - [html](00-intro/slides/00-intro.html) - [qmd](00-intro/slides/00-intro.qmd)
- **Tools for reproducible research** - 09-18-2023 - [html](01-replication-tools/slides/01-replication-tools.html) - [qmd](01-replication-tools/slides/01-replication-tools.qmd)
	+ `examples/` containes some `qmd` documents to demonstrate Quarto features
- **Meta-Analysis and Multi-Lab Replication studies** - 09-19-2023 - [html](02-meta-analysis/slides/02-meta-analysis.html) - [qmd](02-meta-analysis/slides/02-meta-analysis.qmd)
- **Exploring Replicability in Biostatistics** - 09-20-2023 - [html](03-biostatistics/slides/03-biostatistics.html) - [qmd](03-biostatistics/slides/03-biostatistics.qmd)
- **Statistical Methods for Replication Assessment** - 09-21-2023 - [html](04-replication-methods/slides/04-replication-methods.html) - [qmd](04-replication-methods/slides/04-replication-methods.html)