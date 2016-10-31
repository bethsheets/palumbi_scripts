#!/bin/bash

vcfcombine "$@" | vcffilter -f "QUAL > 10" > Q10.vcf
bgzip Q10.vcf
tabix Q10.vcf.gz
bedtools intersect -header -a Q10.vcf.gz -b ../ase.bed > ../aseQ10.vcf
bgzip ../aseQ10.vcf
tabix ../aseQ10.vcf.gz
