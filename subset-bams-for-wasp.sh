#!/bin/bash

#usage in.bed outdir bams

split -l 900 $1 TEMPBED
for i in TEMPBED* ; do sbatch $PI_HOME/scripts/batch-subset-bam.sh $i $2 "${@:3}" ; done
