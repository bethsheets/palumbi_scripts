#!/bin/bash

#SBATCH -p owners
#SBATCH -t 4:00:00

samtools merge merged.bam $@
