#!/bin/bash

#usage: bash plink-from-vcf.sh infile.vcf outfile
#plink files are used in the program admixture

plink --vcf $1 --const-fid --allow-extra-chr 0 --make-bed --out $2

