#!/bin/bash
CHUNK=$2
COUNTER=0
BAM="${@:3}"
echo $BAM
for i in $BAM; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH --ntasks=1\n#SBATCH --cpus-per-task=6\n#SBATCH --mem=24000\n#SBATCH -t 8:00:00\n" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i .bam )
    echo $BASE
    echo "srun bamToFastq -i $i -fq temp$BASE.fq" >> TEMPBATCH.sbatch
    echo "bowtie2 -p 6 --rg-id $BASE --rg SM:$BASE --very-sensitive -x $1 -U temp$BASE.fq > temp$BASE.sam" >> TEMPBATCH.sbatch
    echo "rm temp$BASE.fq" >> TEMPBATCH.sbatch
    echo "samtools view -bSq 10 temp$BASE.sam > ${BASE}_BTVS-UNSORTED.bam " >> TEMPBATCH.sbatch
    echo "rm temp$BASE.sam" >> TEMPBATCH.sbatch
    echo "srun samtools sort ${BASE}_BTVS-UNSORTED.bam ${BASE}_BTVS" >> TEMPBATCH.sbatch
    echo "srun samtools index ${BASE}_BTVS.bam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}_BTVS-UNSORTED.bam" >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi
done
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi 
