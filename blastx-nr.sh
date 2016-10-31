#!/bin/bash
#SBATCH -p owners 
#SBATCH --time=48:00:00
#SBATCH --mem=32000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
########################
# -outfmt 5 XML
# to call: sbatch blastx-nr.sh input.fa

echo $1
#blast against blastnr
blastx -db /scratch/PI/spalumbi/BLAST_db/genbank_nr_Feb_2016/nr -query $1 -out $1.blast.out -evalue 0.001 -max_target_seqs 1 -num_threads 12 -outfmt 5

