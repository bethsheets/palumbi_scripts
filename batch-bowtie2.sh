#!/bin/bash
CHUNK=5
COUNTER=1
BAM="$@"
for i in $BAM; do
    if [ $COUNTER -eq 1 ]; then
    echo -e "#!/bin/bash\n#SBATCH --ntasks=1\n" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i .bam )
    GENO=$(echo $BASE | sed 's/[0-9]*_\([0-9]*\).*/\1/g')
    echo "srun bamToFastq -i $i -fq /dev/stdout | bowtie2 --rg-id $BASE --rg SM:$GENO --very-sensitive -x $HOME/ref/ahy_nosym -U - | samtools view -bS > ${BASE}_BTVS-UNSORTED.bam " >> TEMPBATCH.sbatch
    echo "srun bamtools sort  -in ${BASE}_BTVS-UNSORTED.bam -out ${BASE}_BTVS.bam" >> TEMPBATCH.sbatch 
    echo "srun bamtools index -in ${BASE}_BTVS.bam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}_BTVS-UNSORTED.bam" >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=1; fi
done
if [ $COUNTER -ne $CHUNK ]; then
sbatch TEMPBATCH.sbatch; fi 
