#!/bin/bash
CHUNK=8
COUNTER=1
BAM="$@"
for i in $BAM; do
    if [ $COUNTER -eq 1 ]; then
    echo -e "#!/bin/bash\n#SBATCH --ntasks=1\n" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i .bam )
#    echo "srun bamToFastq -i $i -fq /dev/stdout | bowtie2 --very-sensitive -x $HOME/ref/ahy_nosym -U - | samtools view -bS > ${BASE}_BTVS.bam " >> TEMPBATCH.sbatch
    echo "srun samtools sort ${BASE}_BTVS.bam > ${BASE}_BTVS_SORTED.bam" >> TEMPBATCH.sbatch
    echo srun samtools index ${BASE}_BTVS_SORTED.bam >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=1; fi
done
if [ $COUNTER -ne $CHUNK ]; then
sbatch TEMPBATCH.sbatch; fi 
