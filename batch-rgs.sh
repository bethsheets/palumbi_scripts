#!/bin/bash
CHUNK=16
BAM='/scratch/users/noahrose/*.bam'
COUNTER=0
OUT='/scratch/users/noahrose/geno_bams'
for i in $BAM; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH --ntasks=1\n" > $HOME/TEMPBATCH.sbatch; fi
    BASE=$(basename $i)
    SAMP=$(echo $BASE | sed 's/\([0-9]*\).*/\1/g')
    GENO=$(echo $BASE | sed 's/[0-9]*_\([0-9]*\).*/\1/g')
    echo "srun bamaddrg -cb $i -r $SAMP -s $GENO > $OUT/$SAMP.bam" >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi
done
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi
 
