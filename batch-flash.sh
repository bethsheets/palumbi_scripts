#!/bin/bash

CHUNK=5
COUNTER=0
FILES="$@"

## FLASH merges PE reads

## at prompt, type "bash batch-flash.sh *_1_paired.fastq" 
## you can only merge paired files

## OPTIONS
## -m 10	minimum require overlap length between two reads to provide confident overlap, default 10bp

## CONVENIENCE PARAMETERS FOR CALCULATING MAX OVERLAP. Get these values for your data by running fastxQC.sh and putting into Galaxy
## -r 	read length 
## -f 	fragment length. what's the average from your bioanalyzer plot?
## -s 	fragment standard deviation, ~15-20% fragment length

## Put in your outputs from FastQC and Bioanalyzer
r=125
f=250
s=50

## FLASH PROGRAM
for i in $FILES; do
    
    BASE=$( basename $i _1_paired.fastq )	
    
    if [ $COUNTER -eq 1 ]; then
    echo -e "#!/bin/bash\n#SBATCH --ntasks=1\n#SBATCH -p owners --mem=8000\n" > TEMPBATCH.sbatch; fi
    
    echo "srun flash -m 10 -r ${r} -f ${f} -s ${f} --output-prefix=${BASE}_trimclip_flash ${BASE}_1_paired.fastq ${BASE}_2_paired.fastq" >> TEMPBATCH.sbatch
    
    let COUNTER=COUNTER+1
	
	if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi

done

## this catches all remaining files that are left in the group that is less than $CHUNK files long (if it exists)
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi
