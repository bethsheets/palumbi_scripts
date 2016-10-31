#!/bin/bash
#SBATCH -p owners

#this will submit the filter-assembly.py to the cluster. These two scripts create a new filtered assembly from your good contigs list.

#usage sbatch batch-filter-assembly.sh assembly.fa goodcontigs.txt

BASE=$( basename $1 .fa)
python /share/PI/spalumbi/scripts/filter-assembly.py ${BASE}_filtered.fa ${1} ${2}
