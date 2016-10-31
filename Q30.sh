#!/bin/bash
#SBATCH --mem 12000
#SBATCH --cpus-per-task 2

srun vcffilter -f "QUAL > 30" $1 | vcfallelicprimitives > $2
