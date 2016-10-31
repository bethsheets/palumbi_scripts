#!/bin/bash

#usage: fastVCFcombine.sh outbase vcf(glob)

grep '#' $2 > $1.vcf
for i in ${@:2} ; do grep -v '#' $i >> $1.vcf ; done
