#!/bin/bash

#This script generates batches of 5 paired end sequence files, calls the trimmomatic program, and submits each batch to the cluster

CHUNK=5
COUNTER=0
FILES="$@" #"glob" give me all variables

## at prompt, type "bash batch-trimmomatic-pe.sh *_1.txt.gz"
## _1 is for paired end reads


##options under ILLUMINACLIP
##	2		seedMismatches
##	30		palindromeClipThreshold - accuracy of PE palindrome for removal
##	10		simpleClipThreshold - how accurate a match between adapter and read must be
##	4		minAdapterLength for palindromic adapter detection

## HEADCROP removes the first base (typically lower quality)
## SLIDINGWINDOW - quality average must be 20 over sliding window of 4 bases
## MINLEN sets minimum read length after all trimmings to 200


## PARAMETERS 
ADAPTERS=$PI_HOME/programs/Trimmomatic-0.35/adapters/TruSeq2-PE.fa
LENGTH=100


## TRIMMOMATIC PROGRAM
for i in $FILES; do

    BASE=$(basename $i _1.txt.gz)
    
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH -p owners --mem=8000 --ntasks=1\n" > TEMPBATCH.sbatch; fi
    
    echo "java -jar /share/PI/spalumbi/programs/Trimmomatic-0.35/trimmomatic-0.35.jar PE -threads 8 -phred33 ${BASE}_1.txt.gz ${BASE}_2.txt.gz ${BASE}_1_paired.fastq ${BASE}_1_unpaired.fastq ${BASE}_2_paired.fastq ${BASE}_2_unpaired.fastq ILLUMINACLIP:${ADAPTERS}:2:30:10:4 SLIDINGWINDOW:4:20 MINLEN:${LENGTH}" >> TEMPBATCH.sbatch
    
    let COUNTER=COUNTER+1
	
	if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi

done

## this catches all remaining files that are left in the group that is less than $CHUNK files long (if it exists)
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi

