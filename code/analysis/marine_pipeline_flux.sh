#!/bin/bash

#Use this to run the pipeline with each individual iteration as its own job on flux, instead of
#single back to back interations on one machine

#Usage: marine_pipeline.sh outputdir numseqs trimsize
OUTPUTDIR=$1 #Directory to put output in (must have trailing /)
NUMSEQS=$2 #number of seqs in the dataset (must equal trimsize if trimming)
TRIMSIZE=$3 #size to trim the original dataset too if not using the whole set

mkdir -p $OUTPUTDIR

if [ ! -f data/marine/marine.fasta ] #If raw data does not exist, get the raw data
then
	./code/data/marine.batch
fi

#Subset data (optional)
#Arg to marine_trim.sh is the number of sequences to include in subset
if [ ! -z "$2" ] #if second command line argument is not an empty string
then
	./code/data/marine_trim.sh $OUTPUTDIR $TRIMSIZE
	PREFIX=$(echo $TRIMSIZE.)
else
	PREFIX=""
fi

mothur "#set.dir(input=${OUTPUTDIR}, output=${OUTPUTDIR});
	dist.seqs(fasta=${PREFIX}marine.fasta, cutoff=0.03);"

FINAL=${OUTPUTDIR}marine.${PREFIX}sensspec.final

touch $FINAL
echo "iter	label	cutoff	numotus	tp	tn	fp	fn	sensitivity	specificity	ppv	npv	fdr	accuracy	mcc	f1score	refp	refmcc	sampmcc" >> $FINAL

#Schedule one job per iteration
#Do optifit using various % of the original data as the reference
#REFP iterates from 1..9, times 10 gives us 10..90 in increments of 10
#0% and 100% are skipped because that is equivalent to just running opticlust
for REFPI in {1..9}
do
	for I in {1..10} #10 iters for each REFP
	do
		REFP=$((REFPI*10)) #Counter increments by 1, but we want to increment by 10
		SEQNUM=$(($NUMSEQS-$REFP*$NUMSEQS/100)) #Calculate the actual number of sequences that will be subsampled
		
		#Create and fire off flux jobs
		cat optihead.pbs >> job.pbs
		echo "./code/analysis/optifit_marine.sh ${OUTPUTDIR} ${OUTPUTDIR}${REFPI}_${I}/ $SEQNUM $PREFIX" >> job.pbs #Create different output subdirectories so multiple flux jobs don't interfere with each other
		qsub -N opti_${REFPI}_${I} job.pbs
		done
done

#Get all of the logfiles out of the main directory
mv *.logfile logfiles