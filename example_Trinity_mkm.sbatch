#!/bin/bash 
#################
#set a job name  
#SBATCH --job-name=LOPaired
#################  
#a file for job output, you can check job progress
#SBATCH --output=LOPaired.out
#################
# a file for errors from the job
#SBATCH --error=LOPaired.err
#################
#time you think you need; default is one hour
#in minutes in this case
#SBATCH --time=01:00:00
#################
#quality of service; think of it as job priority
#SBATCH --qos=normal
#SBATCH --ntasks=1
#################
#memory per node; default is 4000 MB per CPU
#SBATCH --mem=4000
#you could use --mem-per-cpu; they mean what we are calling cores
#################
#tasks to run per node; a "task" is usually mapped to a MPI processes.
# for local parallelism (OpenMP or threads), use "--ntasks-per-node=1 --cpus-per-tasks=16" instead
#################
#SBATCH -p hns
#SBATCH --dependency=singleton
#SBATCH -c 8

/share/PI/spalumbi/programs/trinityrnaseq-2.1.1/Trinity --seqType fq --max_memory 256G --CPU 8 --single /scratch/users/kb2018/Lottia_dup/L19_trimmed.fastq,/scratch/users/kb2018/Lottia_dup/L20_trimmed.fastq,/scratch/users/kb2018/Lottia_dup/L7_trimmed.fastq,/scratch/users/kb2018/Lottia_dup/L8_trimmed.fastq
