#!/bin/bash
#usage ref vcfout nnodes "args" BAMS
#args are other freebayes arguments, for instance "-n 3 -P 0.999 -k"
#   this would correspond to, use best three alleles, report 99.9% confident variants, 
#   and don't use population priors; good settings for large samples from multiple pops

REF=$1
NNODE=$3
VCFOUT=$2
ARGS=$4
BAMS="${@:5}"
echo $REF
echo $VCFOUT
echo $BAMS

fasta_generate_regions.py $1 100000 > $VCFOUT/REGIONS.txt
nregions=($(wc -l $VCFOUT/REGIONS.txt))
nlines=$(($nregions /  $NNODE))
echo "Splitting into batches of "$nlines
split $VCFOUT/REGIONS.txt -l $nlines $VCFOUT/TEMP-REGIONS

for i in $VCFOUT/TEMP-REGIONS* ; do
    echo sending out batch $i
    echo -e "#!/bin/bash\n#SBATCH -p owners -c 12" > ${i}.sbatch
    echo "freebayes-parallel $i 12 -f $1 $ARGS $BAMS > ${i}.vcf" >> ${i}.sbatch 
    sbatch ${i}.sbatch
done
