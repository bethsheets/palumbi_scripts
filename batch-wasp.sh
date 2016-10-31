#!/bin/bash
#usage:snpdir bt-ref chunk *.bam
CHUNK=$3
COUNTER=0
BAM="${@:4}"
for i in $BAM; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH --ntasks=1\n#SBATCH --time=6:00:00\n#SBATCH --mem=12000\n" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i .bam )
    echo "srun bash $PI_HOME/scripts/wasp-bam.sh $1 $2 $i" >> TEMPBATCH.sbatch
    let COUNTER=$COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi
done
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi 
