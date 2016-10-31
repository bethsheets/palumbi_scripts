#!/bin/bash
#SBATCH --cpus-per-task=12
#SBATCH -p spalumbi
#SBATCH -t 24:00:00
#usage bams K

angsd -GL 1 -out genolike -nThreads 12 -doGlf 2 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-6 -doMaf 1 -bam $1
NGSadmix -likes genolike.beagle.gz -K $2 -P 12 -o admix -minMaf 0.05

