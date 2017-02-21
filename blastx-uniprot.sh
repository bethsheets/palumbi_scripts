#!/bin/bash 
#SBATCH -p owners
#SBATCH --time=48:00:00
#SBATCH --mem=32000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
########################
# -outfmt 5
# to call: sbatch blastx-uniprot.sh input.fa

#this echoes your TEMP file name to the slurm output in case any files are aborted on owners nodes or have errors
echo $1

#blast against uniprot_db
#remember to update the uniprot_Feb_2016 directory on sherlock regularly

blastx -db /scratch/PI/spalumbi/BLAST_db/uniprot_Nov2016/uniprot_db -query $1 -out $1.blast.out -evalue 0.001 -max_target_seqs 1 -num_threads 6 -outfmt 5

