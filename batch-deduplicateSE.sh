#!/bin/bash

#SBATCH -p spalumbi
#SBATCH --mem=8000

#usage: sbatch batch-deduplicate.sh *.fastq

sbatch usearch8.1.1861_i86linux32 -derep_fulllength $1 -fastqout $1_dedup.fastq -log $1_dedup_log.txt
