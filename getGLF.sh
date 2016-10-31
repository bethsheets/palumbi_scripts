#!/bin/bash
#SBATCH --cpus-per-task=12
#SBATCH -t 24:00:00
#SBATCH -p spalumbi
#usage getGLF.sh bams.txt

angsd -GL 1 -out genolike -nThreads 12 -doGlf 2 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-6 -doMaf 1 -bam $1
