#!/bin/bash
#SBATCH --mem=12000
#SBATCH --time=2:00:00
BASE=$(basename $1 .bam)
srun bamToFastq -i $1 -fq $BASE.fq
srun gzip $BASE.fq
