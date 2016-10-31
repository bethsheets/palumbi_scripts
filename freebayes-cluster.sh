#!/bin/bash
#SBATCH -p owners
# usage: mkdir vcfout
# usage: freebayes-cluster.sh ref.fa vcfout contiglist ncpu "bams"

#make a contig list using fasta2bed.sh on your assembly.fa
#ncpu specify a number of CPUs to use
#glob all of your .bam files

REF=$1
VCFOUT=$2
BAMS="${@:5}"

ncontigs=($(wc -l $3))
nlines=$(($ncontigs /  $4))
echo "Splitting into batches of "$nlines
split $3 -l $nlines TEMP-CONTIG-LIST

for i in TEMP-CONTIG-LIST* ; do
    echo sending out batch $i
    base=$(basename $i) 
    sed "s,CONTIGFILE=.*,CONTIGFILE=\"${i}\",g" $PI_HOME/scripts/freebayes-sequential-intervals.sbatch > ${i}.sbatch
    sed -i "s,VCFOUT=.*,VCFOUT=$VCFOUT,g" ${i}.sbatch
    sed -i "s,--output=.*,--output=${i}.out,g" ${i}.sbatch
    sed -i "s,REF=.*,REF=$REF,g" ${i}.sbatch
    sed -i "s,BAMS=.*,BAMS=\"$BAMS\",g" ${i}.sbatch
    sbatch -p owners ${i}.sbatch
done

