#!/bin/bash
#SBATCH -p spalumbi,owners
#SBATCH --time=48:00:00
#SBATCH --mem=32000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6

#usage: sbatch get-orf-predictions.sh assembly.fa empytyfile outfile
#this script does not use blastx results, so just use an empty file as a placeholder instead 

perl /share/PI/spalumbi/programs/OrfPredictor.pl $1 $2 0 both 1 $3
