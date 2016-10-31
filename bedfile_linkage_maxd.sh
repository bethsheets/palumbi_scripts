#!/bin/bash

if [ $# -eq 0 ]
then echo "usage: reference, bedfile, out directory, maxd, bamfiles"; exit
fi

REF=$1
BED=$2
OUTDIR=$3
BAMS=${@:5}
NUMIND=`expr $# - 4`

for BAM in $BAMS; do
BASE=$(basename $BAM .bam)
samtools mpileup -f $REF -A -l $BED $BAM > ${OUTDIR}/${BASE}.mpileup
sam2pro -c6 -m1 ${OUTDIR}/${BASE}.mpileup > ${OUTDIR}/${BASE}.pro
done

#make GFE infile
echo "Contigs.nuc" > ${OUTDIR}/Samples_MIF.txt
echo $NUMIND >> ${OUTDIR}/Samples_MIF.txt
for BAM in $BAMS; do
BASE=$(basename $BAM .bam)
echo ${BASE}.pro >> ${OUTDIR}/Samples_MIF.txt
done
for BAM in $BAMS; do
BASE=$(basename $BAM .bam)
echo ${BASE} >> ${OUTDIR}/Samples_MIF.txt
done

cut -f1 $BED | uniq | sort -n -k1,1 > ${OUTDIR}/Contigs.txt
xargs samtools faidx $REF < ${OUTDIR}/Contigs.txt > ${OUTDIR}/Contigs.fa
cd $OUTDIR
Ext_Ref_Nuc.pl Contigs.fa Contigs.nuc

Make_InFile $(< Samples_MIF.txt)
paste Contigs.nuc In_GFE_*.txt > Population_GFE.in

GFE -in Population_GFE.in -mode l -out Population_PopLD.in
PopLD_v1.3 -in Population_PopLD.in -out Population_PopLD.out -max_d $4
grep -v NA Population_PopLD.out > linkage.txt
