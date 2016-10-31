#!/bin/bash
#usage:bed outdir chunk *.bam
CHUNK=$3
COUNTER=0
BAM="${@:4}"
for i in $BAM; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH --mem=12000\n#SBATCH -p owners\n" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i .bam )
    echo "samtools view -bL $1 $i > $2/$i" >> TEMPBATCH.sbatch
    echo "samtools index $2/$i" >> TEMPBATCH.sbatch
    let COUNTER=$COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi
done
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi 
