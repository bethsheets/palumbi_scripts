#!/bin/bash
#before running: mkdir vcfout
#usage: bash bcftools_parallel.sh ref.fa vcfout 24 args *.bam
#args are other arguments, for instance "-t DP"

REF=$1
NCPU=$3
VCFOUT=$2
BAMS="${@:4}"
echo $REF
echo $VCFOUT
echo $BAMS

samtools faidx $1
awk '{print $1,"0",$2-1}' ${1}.fai > $VCFOUT/REGIONS.bed
nregions=($(wc -l $VCFOUT/REGIONS.bed))
nlines=$(($nregions /  $NCPU))
echo "Splitting into batches of "$nlines
split $VCFOUT/REGIONS.bed -l $nlines $VCFOUT/TEMP-REGIONS

for i in $VCFOUT/TEMP-REGIONS* ; do
    echo sending out batch $i
    echo -e "#!/bin/bash\n#SBATCH --time=24:00:00 -p spalumbi,owners" > ${i}.sbatch
    echo "samtools mpileup -l $i -t AD -ugf $REF $BAMS | bcftools call -vmO v  > ${i}.vcf" >> ${i}.sbatch 
    sbatch ${i}.sbatch
done
