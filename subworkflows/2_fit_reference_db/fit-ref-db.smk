""" Benchmarking the OptiFit algorithm using an external reference database """
import shutil

# TODO: take a V4 data set and try it against a FL and V4 reference

rule fit_to_external_ref_db:
    input:
        expand('results/{{reference}}-as-reference/{{dataset}}/i-{iter}/{prefix}.opti_mcc.sensspec', weight=weights, reference_fraction=reference_fractions, iter=iters, rep=reps, prefix=['sample', 'reference']),
        expand('results/{{reference}}-as-reference/{{dataset}}/i-{iter}/method-{method}_printref-f/sample.optifit_mcc.sensspec', weight=weights, reference_fraction=reference_fractions, iter=iters, rep=reps, method=methods),
        "results/{reference}-as-reference/{dataset}/aggregate.sensspec"

rule get_reference_names:
    input:
        fasta="data/references/{reference}/{reference}.fasta"
    output:
        names="data/references/{reference}/{reference}.names",
        unique="data/references/{reference}/{reference}.unique.fasta"
    params:
        mothur=mothur_bin,
        output_dir="data/references/{reference}/"
    benchmark:
        "benchmarks/{reference}-as-reference/get_ref_names.log"
    log:
        "logfiles/{reference}-as-reference/get_ref_names.log"
    shell:
        '{params.mothur} "#set.logfile(name={log}); set.dir(output={params.output_dir}); unique.seqs(fasta={input.fasta})" '

rule copy_reference:
    input:
        expand("data/references/{{reference}}/{{reference}}.{ext}", ext=['accnos', 'dist', 'names', 'fasta'])
    output:
        expand("results/{{reference}}-as-reference/{{dataset}}/i-{{iter}}/reference.{ext}", ext=['accnos', 'dist', 'names', 'fasta'])
    benchmark:
        "benchmarks/{reference}-as-reference/{dataset}/i-{iter}/copy_reference.log"
    log:
        "logfiles/{reference}-as-reference/{dataset}/i-{iter}/copy_reference.log"
    run:
        for input_filename, output_filename in zip(input, output):
            if not output_filename.endswith(input_filename.split('.')[-1]):
                raise ValueError(f'Extensions of input & output filenames are not the same! {input_filename} != {output_filename}')
            shutil.copyfile(input_filename, output_filename)

rule reference_cluster:
    input:
        names="results/{reference}-as-reference/{dataset}/i-{iter}/reference.names",
        column="results/{reference}-as-reference/{dataset}/i-{iter}/reference.dist"
    output:
        expand('results/{{reference}}-as-reference/{{dataset}}/i-{{iter}}/reference.opti_mcc.{ext}', ext={'list', 'steps', 'sensspec'})
    params:
        mothur=mothur_bin,
        output_dir='results/{reference}-as-reference/{dataset}/i-{iter}/',
        iter="{iter}"
    benchmark:
        "benchmarks/{reference}-as-reference/{dataset}/i-{iter}/reference.cluster.log"
    log:
        "logfiles/{reference}-as-reference/{dataset}/i-{iter}/reference.cluster.log"
    shell:
        '{params.mothur} "#set.logfile(name={log}); set.seed(seed={params.iter}); set.dir(output={params.output_dir}); cluster(column={input.column}, name={input.names}, cutoff=0.3)"'

rule prep_sample:
    input:
        count="data/{dataset}/{dataset}.count_table",
        column="data/{dataset}/{dataset}.dist",
        fasta="data/{dataset}/{dataset}.fasta"
    output:
        count="results/{reference}-as-reference/{dataset}/i-{iter}/sample.count_table",
        column="results/{reference}-as-reference/{dataset}/i-{iter}/sample.dist",
        fasta="results/{reference}-as-reference/{dataset}/i-{iter}/sample.fasta"
    shell:
        "cp {input.count} {output.count}; "
        "cp {input.column} {output.column}; "
        "cp {input.fasta} {output.fasta}"

rule sample_cluster:
    input:
        count="results/{reference}-as-reference/{dataset}/i-{iter}/sample.count_table",
        column="results/{reference}-as-reference/{dataset}/i-{iter}/sample.dist"
    output:
        expand('results/{{reference}}-as-reference/{{dataset}}/i-{{iter}}/sample.opti_mcc.{ext}', ext={'list', 'steps', 'sensspec'})
    params:
        mothur=mothur_bin,
        output_dir='results/{reference}-as-reference/{dataset}/i-{iter}/',
        iter="{iter}"
    benchmark:
        "benchmarks/{reference}-as-reference/{dataset}/i-{iter}/sample.cluster.log"
    log:
        "logfiles/{reference}-as-reference/{dataset}/i-{iter}/sample.cluster.log"
    shell:
        '{params.mothur} "#set.logfile(name={log}); set.seed(seed={params.iter}); set.dir(output={params.output_dir}); cluster(column={input.column}, count={input.count}, cutoff=0.3)"'

rule fit_to_ref:
    input:
        reflist='results/{reference}-as-reference/{dataset}/i-{iter}/reference.opti_mcc.list',
        refcolumn="results/{reference}-as-reference/{dataset}/i-{iter}/reference.dist",
        reffasta="results/{reference}-as-reference/{dataset}/i-{iter}/reference.fasta",
        fasta='results/{reference}-as-reference/{dataset}/i-{iter}/sample.fasta',
        count="results/{reference}-as-reference/{dataset}/i-{iter}/sample.count_table",
        column="results/{reference}-as-reference/{dataset}/i-{iter}/sample.dist"
    output:
        expand('results/{{reference}}-as-reference/{{dataset}}/i-{{iter}}/method-{{method}}_printref-f/sample.optifit_mcc.{ext}', ext={'list', 'steps', 'sensspec'})
    params:
        mothur=mothur_bin,
        output_dir="results/{reference}-as-reference/{dataset}/i-{iter}/method-{method}_printref-f/",
        iter="{iter}",
        method="{method}"
    benchmark:
        "benchmarks/{reference}-as-reference/{dataset}/i-{iter}/method-{method}_printref-f/fit.log"
    log:
        "logfiles/{reference}-as-reference/{dataset}/i-{iter}/method-{method}_printref-f/fit.log"
    shell:
        '{params.mothur} "#set.logfile(name={log}); set.seed(seed={params.iter}); set.dir(output={params.output_dir}); cluster.fit(reflist={input.reflist}, refcolumn={input.refcolumn}, reffasta={input.reffasta}, fasta={input.fasta}, count={input.count}, column={input.column}, printref=f, method={params.method})"'

rule ref_aggregate_sensspec:
    input:
        opticlust=expand('results/{{reference}}-as-reference/{{dataset}}/i-{iter}/{prefix}.opti_mcc.sensspec', weight=weights, reference_fraction=reference_fractions, iter=iters, rep=reps, prefix=['sample', 'reference']),
        optifit=expand('results/{{reference}}-as-reference/{{dataset}}/i-{iter}/method-{method}_printref-f/sample.optifit_mcc.sensspec', weight=weights, reference_fraction=reference_fractions, iter=iters, rep=reps, method=methods)
    output:
        "results/{reference}-as-reference/{dataset}/aggregate.sensspec"
    params:
        dataset="{dataset}",
        reference_fractions=reference_fractions,
        weights=weights,
        iters=iters,
        reps=reps,
        methods=methods,
        prefixes=['sample','reference']
    benchmark:
        "benchmarks/{reference}-as-reference/{dataset}/aggregate_sensspec.log"
    run:
        header_str = 'iter\tlabel\tcutoff\tnumotus\ttp\ttn\tfp\tfn\tsensitivity\tspecificity\tppv\tnpv\tfdr\taccuracy\tmcc\tf1score\treference_fraction\titer\trep\ttype\n'
        with open(output[0], 'w') as output_file:
            output_file.write(header_str)
            for weight in params.weights:
                for reference_fraction in params.reference_fractions:
                    for iter in params.iters:
                        for rep in params.reps:
                            for prefix in params.prefixes:
                                input_filename = f'results/{reference}-as-reference/{params.dataset}/i-{iter}/{prefix}.opti_mcc.sensspec'
                                with open(input_filename, 'r') as input_file:
                                    for line in input_file:
                                        pass
                                    opticlust_result = re.sub(r'(\S*\t\S*\t)(.*)', r'\t\1\t\2', line).rstrip()
                                    output_file.write(f"{opticlust_result}\t{reference_fraction}\t{iter}\t{rep}\t{prefix}\n")
                            for method in params.methods:
                                input_filename = f"results/{reference}-as-reference/{params.dataset}/i-{iter}/method-{method}_printref-f/sample.optifit_mcc.sensspec"
                                with open(input_filename, 'r') as input_file:
                                    for line in input_file:
                                        pass
                                    line = line.strip()
                                    output_file.write(f"{line}\t{reference_fraction}\t{iter}\t{rep}\tmethod-{method}_printref-f\n")