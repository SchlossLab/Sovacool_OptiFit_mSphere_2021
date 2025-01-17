# OptiFit <a href='http://github.com/SchlossLab/Sovacool_OptiFit_2021/'><img src='https://raw.githubusercontent.com/mothur/logo/master/mothur_RGB.png' align="right" height="120" /></a>

### an improved method for fitting amplicon sequences to existing OTUs

[![build](https://github.com/SchlossLab/Sovacool_OptiFit_2021/actions/workflows/build.yml/badge.svg)](https://github.com/SchlossLab/Sovacool_OptiFit_2021/actions/workflows/build.yml)
[![license](https://img.shields.io/badge/License-MIT%2BCC--BY-blue)](https://github.com/SchlossLab/Sovacool_OptiFit_2021/blob/main/LICENSE.md)
[![DOI](https://zenodo.org/badge/150322192.svg)](https://zenodo.org/badge/latestdoi/150322192)
[![paper](https://img.shields.io/badge/paper-mSphere-red)](https://journals.asm.org/doi/10.1128/msphere.00916-21)

This repository contains the complete analysis workflow used to benchmark the
OptiFit algorithm in [mothur](https://github.com/mothur/mothur)
and produce the accompanying [manuscript](docs/paper.pdf).
Find details on how to use OptiFit and descriptions of the parameter options on
the mothur wiki: https://mothur.org/wiki/cluster.fit/.

## Citation

> Sovacool KL, Westcott SL, Mumphrey MB, Dotson GA, Schloss PD. 
> 2022. OptiFit: An Improved Method for Fitting Amplicon Sequences to Existing OTUs. 
> mSphere. http://dx.doi.org/10.1128/msphere.00916-21

A bibtex entry for LaTeX users:

```
@article{sovacool_optifit_2022,
author = {Kelly L. Sovacool  and Sarah L. Westcott  and M. Brodie Mumphrey  and Gabrielle A. Dotson  and Patrick D. Schloss},
title = {OptiFit: an Improved Method for Fitting Amplicon Sequences to Existing OTUs},
journal = {mSphere},
year = {2022},
doi = {10.1128/msphere.00916-21}
URL = {https://journals.asm.org/doi/10.1128/msphere.00916-21},
```

## The Workflow

The workflow is split into five subworkflows:

- **[0_prep_db](subworkflows/0_prep_db)** — download & preprocess reference
    databases.
- **[1_prep_samples](subworkflows/1_prep_samples)** — download, preprocess, &
    _de novo_ cluster the sample datasets.
- **[2_fit_reference_db](subworkflows/2_fit_reference_db)** — fit datasets to
    reference databases.
- **[3_fit_sample_split](subworkflows/3_fit_sample_split)** — split datasets;
    cluster one fraction _de novo_ and fit the remaining sequences to the
    _de novo_ OTUs.
- **[4_vsearch](subworkflows/4_vsearch)** — run vsearch clustering for
    comparison.

The main workflow ([`Snakefile`](Snakefile)) creates plots from the results of
the subworkflows and renders the [paper](paper).

## Quickstart

1. Before cloning, configure git symlinks:
   
   ```bash
    git config --global core.symlinks true
    ```
    Otherwise, git will create text files in place of symlinks.
    
1. Clone this repository.
   
   ```bash
    git clone https://github.com/SchlossLab/Sovacool_OptiFit_mSphere_2022
    cd Sovacool_OptiFit_mSphere_2022
    ```
    
1. Install the dependencies.
    
    Almost all are listed in the conda environment file.
    Everything needed to run the analysis workflow is listed here.
    ```bash
    conda env create -f config/env.simple.yaml
    conda activate optifit
    ```
    
    Additionally, I used a custom version of
    [`ggraph`](https://ggraph.data-imaginist.com/)
    for the algorithm figure.
    You can install it with `devtools` from R:
    ```r
    devtools::install_github('kelly-sovacool/ggraph', ref = 'iss-297_ggtext')
    ```
    
    If you do not have LaTeX already, you'll need to install a LaTeX
    distribution before rendering the manuscript as a PDF.
    You can use [`tinytex`](https://yihui.org/tinytex/)
    to do so:
    ```r
    tinytex::install_tinytex()
    ```

    I also used [`latexdiffr`](https://github.com/hughjonesd/latexdiffr) 
    to create a PDF with changes tracked prior to
    submitting revisions to the journal.
    ```r
    devtools::install_github("hughjonesd/latexdiffr")
    ```
    
1. Run the entire pipeline.

    Locally:
    ```
    snakemake --cores 4
    ```
    
    Or on an HPC running slurm:
    ```
    sbatch code/slurm/submit_all.sh
    ```
    (You will first need to edit your email and slurm account info in the
    [submission script](code/slurm/)
    and [cluster config](config/cluster.json).)

## Directory Structure

```
.
├── OptiFit.Rproj
├── README.md
├── Snakefile
├── code
│   ├── R
│   ├── bash
│   ├── py
│   ├── slurm
│   └── tests
├── config
│   ├── cluster.json
│   ├── config.yaml
│   ├── config_test.yaml
│   ├── env.export.yaml
│   ├── env.simple.yaml
│   └── slurm
│       └── config.yaml
├── docs
│   ├── paper.md
│   ├── paper.pdf
│   └── slides
├── exploratory
│   ├── 2018_fall_rotation
│   ├── 2019_winter_rotation
│   ├── 2020-05_May-Oct
│   ├── 2020-11_Nov-Dec
│   ├── 2021
│   │   ├── figures
│   │   ├── plots.Rmd
│   │   ├── plots.md
│   ├── AnalysisRoadmap.md
│   └── DeveloperNotes.md
├── figures
├── log
├── paper
│   ├── figures.yaml
│   ├── head.tex
│   ├── msphere.csl
│   ├── paper.Rmd
│   ├── preamble.tex
│   └── references.bib
├── results
│   ├── aggregated.tsv
│   ├── stats.RData
│   └── summarized.tsv
└── subworkflows
    ├── 0_prep_db
    │   ├── README.md
    │   └── Snakefile
    ├── 1_prep_samples
    │   ├── README.md
    │   ├── Snakefile
    │   ├── data
    │   │   ├── human
    │   │       └── SRR_Acc_List.txt
    │   │   ├── marine
    │   │       └── SRR_Acc_List.txt
    │   │   ├── mouse
    │   │       └── SRR_Acc_List.txt
    │   │   └── soil
    │   │       └── SRR_Acc_List.txt
    │   └── results
    │       ├── dataset_sizes.tsv
    │       └── opticlust_results.tsv
    ├── 2_fit_reference_db
    │   ├── README.md
    │   ├── Snakefile
    │   └── results
    │       ├── denovo_dbs.tsv
    │       ├── optifit_dbs_results.tsv
    │       └── ref_sizes.tsv
    ├── 3_fit_sample_split
    │   ├── README.md
    │   ├── Snakefile
    │   └── results
    │       ├── optifit_crit_check.tsv
    │       └── optifit_split_results.tsv
    └── 4_vsearch
        ├── README.md
        ├── Snakefile
        └── results
            └── vsearch_results.tsv
```
