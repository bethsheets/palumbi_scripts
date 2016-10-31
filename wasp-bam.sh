#!/bin/bash
#usage SNPdir bt-index bam
BASE=$(basename $3 .bam)
echo $BASE
python $PI_HOME/programs/WASP/mapping/find_intersecting_snps.py $3 $1
echo "remapping..."
bowtie2 --very-sensitive -x $2 -U $BASE.remap.fq.gz > $BASE.remapped.sam
samtools view -bSq 10  $BASE.remapped.sam > $BASE.remapped.bam
python $PI_HOME/programs/WASP/mapping/filter_remapped_reads.py $BASE.to.remap.bam $BASE.remapped.bam $BASE.ok.bam $BASE.to.remap.num.gz
samtools merge -f $BASE.final.bam $BASE.ok.bam $BASE.keep.bam
samtools index $BASE.final.bam
rm $BASE.ok.bam
rm $BASE.keep.bam
rm $BASE.remap.fq.gz
rm $BASE.remapped.bam
rm $BASE.to.remap*
rm $BASE.sort.bam
rm $BASE.remapped.sam
