#!/bin/bash

#SBATCH --mem=144000
#SBATCH --qos=bigmem
#SBATCH --partition=bigmem

$PI_SCRATCH/Kraken/kraken --threads 3 --gzip-compressed --db $PI_SCRATCH/krakenDB/krakenDB --fastq-input /scratch/users/noahrose/11892R/Fastq/11892X1_151007_D00294_0202_AC7FK3ANXX_8_1.txt.gz
