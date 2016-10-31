#!/bin/bash

## Script to call parallel sbatch jobs for generating fastQ quality stats for Galaxy
## usage: batch-fastx-qualstats.sh *_1.fastq.gz

CHUNK=5
COUNTER=0
FILES="$@"

for i in $FILES; do

    BASE=$(basename $i _1.fastq.gz)
    
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH --ntasks=1\n" > TEMPBATCH.sbatch; fi
    echo "srun fastx_quality_stats -Q33 -i $i -o ${BASE}.qualstats.txt" >> TEMPBATCH.sbatch
   
    let COUNTER=COUNTER+1
	
	if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi

done

if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi
