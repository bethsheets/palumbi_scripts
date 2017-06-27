#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH --time=24:00:00
#SBATCH -c 16

#you need to generate a bayescan file from hierfstat as an input file
#usage: sbatch bayescan.sh input.bsc

/share/PI/spalumbi/programs/BayeScan2.1/source/bayescan_2.1 -snp -out_freq $1
