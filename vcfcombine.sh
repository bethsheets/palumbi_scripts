#!/bin/bash

#SBATCH -p owners
#SBATCH -t 5:00:00
#SBATCH --mem=12000

srun vcfcombine $@ > combined.vcf
