#!/bin/bash
#SBATCH --mem 12000
#SBATCH --cpus-per-task 2

srun vcffilter -f "QUAL > 30 & TYPE = snp & NUMALT = 1 & NS = $1 & AF > 0.05 & AF < 0.95" $2 | vcfallelicprimitives > $3
