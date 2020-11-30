" Download references & datasets, process with mothur, and benchmark the OptiFit algorithm "

configfile: 'config/config.yaml'

subworkflow prep_db:
    workdir:
        "subworkflows/0_prep_db/"
    configfile:
        config['configpath']

subworkflow prep_samples:
    workdir:
        "subworkflows/1_prep_samples/"
    configfile:
        config['configpath']

subworkflow fit_ref_db:
    workdir:
        "subworkflows/2_fit_reference_db/"
    configfile:
        config['configpath']

subworkflow fit_split:
    workdir:
        "subworkflows/3_fit_sample_split/"
    configfile:
        config['configpath']

subworkflow vsearch:
    workdir:
        "subworkflows/4_vsearch/"
    configfile:
        config['configpath']

rule targets:
    input:
        'paper/paper.pdf'

rule subtargets:
    input:
        opticlust=prep_samples('results/opticlust_results.tsv'),
        optifit_db=fit_ref_db('results/optifit_dbs_results.tsv'),
        optifit_split=fit_split('results/optifit_split_results.tsv'),
        vsearch=vsearch('results/vsearch_results.tsv')

rule render_paper:
    input:
        Rmd="paper/paper.Rmd",
        pre='paper/header.tex',
        bib='paper/references.bib',
        csl='paper/msystems.csl',
        R='code/R/render.R',
        fcns="code/R/functions.R"
    output:
        pdf='paper/paper.pdf',
        html='docs/paper.html'
    params:
        site_dir='docs/',
    script:
        'code/R/render.R'


