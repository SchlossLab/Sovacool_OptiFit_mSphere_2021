mothur = "mothur '#set.dir(input=data/rdp/, output=data/rdp/); set.logfile(name={log}) "
rule rdp_targets:
    input:
        expand("data/rdp/rdp.{ext}", ext={'tax', 'fasta'})

rule download_rdp:
    output:
        "data/rdp/Trainset16_022016.rdp.tgz"
    shell:
        "wget -N -P data/rdp/ https://www.mothur.org/w/images/d/dc/Trainset16_022016.rdp.tgz"

rule unpack_rdp_db:
    input:
        rules.download_rdp.output
    output:
        fasta="data/rdp/rdp.fasta",
        tax="data/rdp/rdp.tax"
    shell:
        """
        tar xvzf {input} -C data/rdp/
        mv data/rdp/trainset16_022016.rdp/trainset16_022016.rdp.fasta {output.fasta}
        mv data/rdp/trainset16_022016.rdp/trainset16_022016.rdp.tax {output.tax}
        rm -rf data/rdp/trainset16_022016.rdp/
        """

rule get_rdp_bact:
    input:
        fasta=rules.unpack_rdp_db.output.fasta,
        tax=rules.unpack_rdp_db.output.fasta
    output:
        fasta="data/rdp/rdp.bacteria.fasta",
        tax="data/rdp/rdp.bacteria.tax"
    log:
        "logfiles/rdp/get_rdp_bact.log"
    shell:
        """
        {mothur}
        get.lineage(fasta={input.fasta}, tax={input.tax}, taxon=Bacteria)'
        mv data/rdp/rdp.pick.fasta {output.fasta}
        mv data/rdp/rdp.pick.tax {output.tax}
        """

rule get_full_length_rdp:
    input:
        fasta=rules.get_rdp_bact.output.fasta,
        tax=rules.get_rdp_bact.output.tax
    output:
        ""
    shell:
        """
        {mothur}
        """
