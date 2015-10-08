#!/bin/bash
CHUNK=8
COUNTER=1
for i in $BAM; do
    if [ $COUNTER -eq 1 ]; then
    echo -e "#!/bin/bash\n#SBATCH --ntasks=1\n" > $HOME/TEMPBATCH.sbatch; fi
    echo "srun bwa mem" >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=1; fi
done
if [ $COUNTER -ne $CHUNK ]; then
sbatch TEMPBATCH.sbatch; fi
 
