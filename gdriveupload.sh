#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=16000
#SBATCH -t 24:00:00
#usage: the directory that you want to upload to google drive
ml load gdrive
gdrive upload --recursive $1
