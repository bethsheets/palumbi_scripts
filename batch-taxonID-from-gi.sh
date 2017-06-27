#!/bin/bash
#SBATCH -p spalumbi,owners
#SBATCH --mem=96000

#this will submit the filter-assembly.py to the cluster. These two scripts create a new filtered assembly from your good contigs list.

#usage sbatch batch-taxonID-from-gi.sh type('n' or 'p') GIlist output

python /share/PI/spalumbi/scripts/get_taxid_from_gi_j.py $1 $2 $3
