#!/bin/bash
module load R
NSAMPS=37
MINALT=2
MAXALT=$(($NSAMPS * 2 - $MINALT ))
QUAL=30
GQ=30
OUT=RAB-field-GQ30-HETS
NUMALT=1
vcfcombine "$@" | vcfflatten | vcffilter -f "QUAL > $QUAL & ( TYPE = snp | TYPE = mnp ) & AC > $MINALT & AC < $MAXALT & NUMALT = $NUMALT" -g "GQ > $GQ & GT = 0/1" | vcffixup - | vcffilter -f "AC > $MINALT" > $OUT.vcf
vcf2tsv -g $OUT.vcf > $OUT.tsv
bgzip < $OUT.vcf > $OUT.vcf.gz
tabix -p vcf $OUT.vcf.gz
