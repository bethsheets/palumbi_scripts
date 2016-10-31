#!/bin/bash
CHUNK=5
COUNTER=0
FILES="$@" #"glob" give me all variables

## usage: bash batch-trimmomatic-se.sh *.fastq


##options under ILLUMINACLIP
##      2               seedMismatches
##      30              palindromeClipThreshold - accuracy of PE palindrome for removal
##      10              simpleClipThreshold - how accurate a match between adapter and read must be
##      4               minAdapterLength for palindromic adapter detection

## HEADCROP removes the first base (typically lower quality)
## SLIDINGWINDOW - quality average must be 20 over sliding window of 4 bases
## MINLEN sets minimum read length after all trimmings to 200


## PARAMETERS. YOU MAY NEED TO CHANGE THESE FOR YOUR DATASET!
ADAPTERS=$PI_HOME/programs/Trimmomatic-0.35/adapters/TruSeq2-SE.fa
LENGTH=36  #for SE 50bp


## TRIMMOMATIC PROGRAM
for i in $FILES; do

    BASE=$(basename $i .fastq)
    
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH -p owners --mem=8000 --ntasks=1\n" > TEMPBATCH.sbatch; fi
	
    echo "java -jar $PI_HOME/programs/Trimmomatic-0.35/trimmomatic-0.35.jar SE -phred33 ${BASE}.fastq ${BASE}_trimmed.fastq ILLUMINACLIP:${ADAPTERS}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:${LENGTH}" >> TEMPBATCH.sbatch
	
	let COUNTER=COUNTER+1
        
        if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi

done

## this catches all remaining files that are left in the group that is less than $CHUNK files long (if it exists)
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi
