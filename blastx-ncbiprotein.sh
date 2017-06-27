#!/bin/bash
#SBATCH -p owners
#SBATCH --time=48:00:00
#SBATCH --mem=16000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
########################
# -outfmt 5 XML
# to call: sbatch blastx-ncbiprotein.sh input.fa

echo $1
#blast against blastnr
blastx -db /scratch/PI/spalumbi/BLAST_db/ncbi_protein_April2017/refseq_protein -query $1 -out $1.blast.out -evalue 0.001 -max_target_seqs 1 -num_threads 12 -outfmt 5
