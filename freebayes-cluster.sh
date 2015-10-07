#!/bin/bash
# usage: freebayes-cluster.sh ref.fa vcfoutdir contiglist ncpu "bams"

REF=$1
VCFOUT=$2
BAMS=$5

ncontigs=($(wc -l $3))
nlines=$(($ncontigs /  $4))
echo "Splitting into batches of "$nlines
rm $SCRATCH/TEMP/LISTS/TEMP-CONTIG-LIST*
split $3 -l $nlines $SCRATCH/TEMP/LISTS/TEMP-CONTIG-LIST

COUNTER=1
for i in $SCRATCH/TEMP/LISTS/TEMP-CONTIG-LIST* ; do
    echo sending out batch $i
    base=$(basename $i) 
    sed "s,CONTIGFILE=.*,CONTIGFILE=$i,g" $HOME/scripts/freebayes-sequential.sbatch > $SCRATCH/TEMP/SBATCH/${base}_TEMPBATCH.sbatch
    sed -i "s,VCFOUT=.*,VCFOUT=$VCFOUT,g" $SCRATCH/TEMP/SBATCH/${base}_TEMPBATCH.sbatch
    sed -i "s,REF=.*,REF=$REF,g" $SCRATCH/TEMP/SBATCH/${base}_TEMPBATCH.sbatch
    sed -i "s,BAMS=.*,BAMS=$BAMS,g" $SCRATCH/TEMP/SBATCH/${base}_TEMPBATCH.sbatch
    #sbatch $SCRATCH/TEMP/SBATCH/${base}_TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
done

