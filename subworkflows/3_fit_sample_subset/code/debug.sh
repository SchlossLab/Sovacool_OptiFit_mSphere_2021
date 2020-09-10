#!/bin/bash

##################
####  Slurm preamble

#### #### ####  These are the most frequently changing options

####  Job name
#SBATCH --job-name=sub3

####  Request resources here
####    These are typically, number of processors, amount of memory,
####    an the amount of time a job requires.  May include processor
####    type, too.

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500MB
#SBATCH --time=48:00:00

#SBATCH --output=log/hpc/slurm-%j_%x.out

####  Slurm account and partition specification here
####    These will change if you work on multiple projects, or need
####    special hardware, like large memory nodes or GPUs.

#SBATCH --account=pschloss99
#SBATCH --partition=standard

#### #### ####  These are the least frequently changing options

####  Your e-mail address and when you want e-mail

#SBATCH --mail-user=sovacool@umich.edu
#SBATCH --mail-type=BEGIN,END

time snakemake --profile ../../config/slurm --latency-wait 90 --configfile ../../config/config.yaml --forcerun merge_benchmarks
