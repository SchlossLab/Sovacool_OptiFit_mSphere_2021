
rule merge_sensspec1:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=expand('results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/{dataset}.pick.optifit_mcc.mod.sensspec',
            dataset=datasets, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds, method=methods, printref=printrefs)
    output:
        tsv="results/fixed-sample/sensspec.tsv"
    log:
        'log/merge_sensspec.fixed-sample.tsv'
    benchmark:
        'benchmarks/merge_sensspec.fixed-sample.txt'
    script:
        '../../code/R/merge_results.R'

rule merge_benchmarks1:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=expand('benchmarks/{dataset}/fit.method_{method}.printref_{printref}.refweight_{ref_weight}.reffrac_{ref_frac}.samplefrac_{sample_frac}.seed_{seed}.mod.txt',
            dataset=datasets, method=methods, printref=printrefs, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds)
    output:
        tsv="results/fixed-sample/benchmarks.tsv"
    log:
        'log/merge_benchmarks.fixed-sample.tsv'
    benchmark:
        'benchmarks/merge_benchmarks.fixed-sample.txt'
    script:
        '../../code/R/merge_results.R'

rule merge_fractions1:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=expand('results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/fraction_reads_mapped.txt',
            dataset=datasets, method=['closed'], printref=printrefs, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds)
    output:
        tsv="results/fixed-sample/fraction_reads_mapped.tsv"
    log:
        'log/merge_fractions.fixed-sample.tsv'
    benchmark:
        'benchmarks/merge_fractions.fixed-sample.txt'
    script:
        '../../code/R/merge_results.R'

rule merge_sizes1:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=expand("results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/input_size.tsv",
            dataset=datasets, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds)
    output:
        tsv="results/fixed-sample/input_sizes.tsv"
    log:
        'log/merge_sizes.fixed-sample.tsv'
    benchmark:
        'benchmarks/merge_sizes.fixed-sample.txt'
    script:
        '../../code/R/merge_results.R'

rule merge_gap_counts1:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=expand('results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/gaps_count.tsv',
            dataset=datasets, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds)
    output:
        tsv='results/fixed-sample/gap_counts.tsv'
    log:
        'log/merge_gap_counts.tsv'
    script:
        '../../code/R/merge_results.R'

rule merge_diversity1:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=expand('results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/{dataset}.pick.optifit_mcc.summary',
            dataset=datasets, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds, method=methods, printref=printrefs)
    output:
        tsv='results/fixed-sample/diversity.tsv'
    script:
        '../../code/R/merge_results.R'

rule merge_sensspec2:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=[f'results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/{dataset}.pick.optifit_mcc.mod.sensspec' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs]
    output:
        tsv="results/all-seqs/sensspec.tsv"
    log:
        'log/merge_sensspec.all-seqs.tsv'
    benchmark:
        'benchmarks/merge_sensspec.all-seqs.txt'
    script:
        '../../code/R/merge_results.R'

rule merge_benchmarks2:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=[f'benchmarks/{dataset}/fit.method_{method}.printref_{printref}.refweight_{ref_weight}.reffrac_{ref_frac}.samplefrac_{sample_frac}.seed_{seed}.mod.txt' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs]
    output:
        tsv="results/all-seqs/benchmarks.tsv"
    log:
        'log/merge_benchmarks.all-seqs.tsv'
    benchmark:
        'benchmarks/merge_benchmarks.all-seqs.txt'
    script:
        '../../code/R/merge_results.R'

rule merge_fractions2:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=[f'results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_closed/printref_{printref}/fraction_reads_mapped.txt' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for printref in printrefs]
    output:
        tsv="results/all-seqs/fraction_reads_mapped.tsv"
    log:
        'log/merge_fractions.all-seqs.tsv'
    benchmark:
        'benchmarks/merge_fractions.all-seqs.txt'
    script:
        '../../code/R/merge_results.R'

rule merge_sizes2:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=[f"results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/input_size.tsv" for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs]
    output:
        tsv="results/all-seqs/input_sizes.tsv"
    log:
        'log/merge_sizes.all-seqs.tsv'
    benchmark:
        'benchmarks/merge_sizes.all-seqs.txt'
    script:
        '../../code/R/merge_results.R'

rule merge_gap_counts2:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=[f'results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/gaps_count.tsv' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs]
    output:
        tsv='results/all-seqs/gap_counts.tsv'
    script:
        '../../code/R/merge_results.R'

rule merge_diversity2:
    input:
        code='../../code/R/merge_results.R',
        fcns='../../code/R/functions.R',
        tsv=[f'results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/{dataset}.pick.optifit_mcc.summary' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs]
    output:
        tsv='results/all-seqs/diversity.tsv'
    script:
        '../../code/R/merge_results.R'

rule merge_all_inputs:
    input:
        expand('results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/{dataset}.pick.optifit_mcc.mod.sensspec',
            dataset=datasets, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds, method=methods, printref=printrefs),
        expand('benchmarks/{dataset}/fit.method_{method}.printref_{printref}.refweight_{ref_weight}.reffrac_{ref_frac}.samplefrac_{sample_frac}.seed_{seed}.mod.txt',
            dataset=datasets, method=methods, printref=printrefs, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds),
        expand('results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/fraction_reads_mapped.txt',
            dataset=datasets, method=['closed'], printref=printrefs, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds),
        expand("results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/input_size.tsv",
            dataset=datasets, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds),
        expand('results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/gaps_count.tsv',
            dataset=datasets, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds),
        expand('results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/{dataset}.pick.optifit_mcc.summary',
            dataset=datasets, ref_weight=random_refweight_options, ref_frac=ref_fracs, sample_frac=sample_frac_fixed, seed=seeds, method=methods, printref=printrefs),
        [f'results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/{dataset}.pick.optifit_mcc.mod.sensspec' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs],
        [f'benchmarks/{dataset}/fit.method_{method}.printref_{printref}.refweight_{ref_weight}.reffrac_{ref_frac}.samplefrac_{sample_frac}.seed_{seed}.mod.txt' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs],
        [f'results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_closed/printref_{printref}/fraction_reads_mapped.txt' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for printref in printrefs],
        [f"results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/input_size.tsv" for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs],
        [f'results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/gaps_count.tsv' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs],
        [f'results/{dataset}/refweight_{ref_weight}/reffrac_{ref_frac}/samplefrac_{sample_frac}/seed_{seed}/fit/method_{method}/printref_{printref}/{dataset}.pick.optifit_mcc.summary' for ref_frac, sample_frac in zip(ref_fracs, sample_fracs_varied) for dataset in datasets for ref_weight in random_refweight_options for seed in seeds for method in methods for printref in printrefs]