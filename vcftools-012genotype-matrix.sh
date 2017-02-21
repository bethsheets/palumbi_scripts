#!/bin/bash

usage: bash vcftools-012genotype-matrix.sh combined_filtered.vcf outfile

vcftools --vcf $1 --012 --out $2
