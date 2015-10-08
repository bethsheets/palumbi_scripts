#!/bin/bash
BAM=$1
BASE=$(basename $BAM .bam)
GENO=$(echo $BASE | sed 's/[0-9]*_\([0-9]*\).*/\1/g')
mkdir TEMP-$BASE
mv $BASE.hq.bam TEMP-$BASE
cd TEMP-$BASE
SNPDIR=$SCRATCH/TEMP/VCF/SNPDIR/SOME
WASP=$HOME/bin/WASP/mapping

echo "finding reads with SNPs..."
python $WASP/find_intersecting_snps.py $BASE.bam $SNPDIR

echo "remapping..."
bowtie2 --rg-id $BASE --rg SM:$GENO --very-sensitive -x $HOME/ref/ahy_nosym -U $BASE.remap.fq.gz | samtools view -bS > $BASE.remap.bam

echo "filtering biased mappers..."
python $WASP/filter_remapped_reads.py $BASE.to.remap.bam $BASE.remap.bam $BASE.remap.keep.bam $BASE.to.remap.num.gz

echo "merging..."
samtools merge $BASE.wasp.bam $BASE.keep.bam $BASE.remap.keep.bam
mv $BASE.wasp.bam ..
cd ..
rm -rf TEMP-$BASE
