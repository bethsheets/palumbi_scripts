#!/bin/bash
#
#all commands that start with SBATCH contain commands that are just used by SLURM for scheduling
#################
#set a job name
#SBATCH --job-name=TrimTest
#################
#a file for job output, you can check job progress
#SBATCH --output=Trimmomatic_Paired.out
#################
# a file for errors from the job
#SBATCH --error=Trimmomatic_Paired.err
#################
#time you think you need; default is one hour
#in minutes in this case
#SBATCH --time=20:00:00
#################
#quality of service; think of it as job priority
#SBATCH --qos=normal
#SBATCH --ntasks=1
#################
#memory per node; default is 4000 MB per CPU
#SBATCH --mem=16000
#you could use --mem-per-cpu; they mean what we are calling cores
#################
#tasks to run per node; a "task" is usually mapped to a MPI processes.
# for local parallelism (OpenMP or threads), use "--ntasks-per-node=1 --cpus-per-tasks=16" instead
#################


java -jar /home/mkm44/Programs/trinityrnaseq-2.1.1/trinity-plugins/Trimmomatic/trimmomatic.jar PE -phred33 /scratch/users/mkm44/Multispecies/LO03_03_R_75_P1_1.fq /scratch/users/mkm44/Multispecies/LO03_03_R_75_P1_2.fq /scratch/users/mkm44/Multispecies/30bp/30bp_LO03_03_R_75_P1_TrimClip_forward_paired.fq /scratch/users/mkm44/Multispecies/30bp/30bp_LO03_03_R_75_P1_TrimClip_forward_unpaired.fq /scratch/users/mkm44/Multispecies/30bp/30bp_LO03_03_R_75_P1_TrimClip_reverse_paried.fq /scratch/users/mkm44/Multispecies/30bp/30bp_LO03_03_R_75_P1_TrimClip_reverse_unpaired.fq ILLUMINACLIP:/home/mkm44/Programs/trinityrnaseq-2.1.1/trinity-plugins/Trimmomatic/adapters/Truseq2_Palumbi_Index.fasta:2:30:10 SLIDINGWINDOW:4:20 LEADING:10 TRAILING:10 MINLEN:30
