#!/bin/bash 
#SBATCH --job-name=Lob09
#SBATCH --output=Out_Lob09.out
#SBATCH --error=Err_Lob09.err
#SBATCH --time=24:00:00
#SBATCH --qos=normal
#SBATCH --mem=4000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16

/scratch/users/mkm44/BLAST/ncbi-blast-2.3.0+-src/c++/ReleaseMT/bin/tblastx -query /scratch/users/mkm44/Jobs/BLAST_Jobs/coral_evale-10/Lob400000.fasta -db /scratch/users/mkm44/BLAST/db/Coral_transcripts/Coral_transcripts_1569069.fa -out /scratch/users/mkm44/Jobs/BLAST_Jobs/Lob_allcoraltblastx_evale-10_09.txt -evalue 0.0000000001 -max_target_seqs 5 -num_threads 16 -outfmt '10 qseqid qlen sseqid evalue bitscore length pident qcovs'

