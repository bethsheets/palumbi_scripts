#!/bin/bash
#SBATCH --mem=12000

srun bedtools maskfasta -fi $1 -fo $2 -bed $3
srun samtools faidx $2
