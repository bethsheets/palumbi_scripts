#!/bin/bash

#SBATCH --time=8:00:00
#SBATCH -p owners,spalumbi
#SBATCH --mem=24000

### OPTIONS FOR SHORT READS

# -i specify segment pair score cutoff N > 20 (40)
#The -i option is used to specify a score cutoff on segment pairs (ungapped alignments).
#The score of a segment pair with 19 base matches and 1 base mismatch is 2 * 19 + (-5) * 1 = 33,
# where each base match is given a score of 2 and each mismatch is given a score of -5.

# -j specify chain score cutoff N > 30 (80)
#The -j option is used to specify a score cutoff on chains of segment pairs,
#where the score of a chain is the sum of scores of each segment pair
#minus penalties for gaps between segment pairs.
#The score of a chain consisting of one segment pair is simply the score of
#the segment pair.

# -o specify overlap length cutoff > 15 (40)
# -s specify overlap similarity score cutoff N > 250 (900)
#The -o option is used to specify a length cutoff on overlaps,
#whereas the -s option is used to specify a score cutoff (based on matches, mismatches, and gaps) on overlaps.

# -p specify overlap percent identity cutoff N > 65 (90)

#to call: sbatch cap3.sh <yourassembly>.fasta

cap3 $1 

#recommended for short reads
#-i 30 -j 31 -o 18 -s 300 
