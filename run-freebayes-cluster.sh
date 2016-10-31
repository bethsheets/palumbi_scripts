#ref vcfoutdir contigs cores bams
bash freebayes-cluster.sh \
/home/noahrose/ref/ahy_nosym.fa \
/scratch/users/noahrose/TEMP/VCF \
/home/noahrose/ref/ahy_nosym.bed \
24 \
$SCRATCH/geno_bams/ctrl/*BTVS.bam $SCRATCH/geno_bams/heat/*BTVS.bam
