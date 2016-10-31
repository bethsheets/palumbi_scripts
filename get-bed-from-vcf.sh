#!/bin/bash 
# usage: vcf ref.bed out.bed

cut -f 1 $1 | uniq | sed 's/\(^.*\)/\1\t/g' > TEMPLIST
grep -Ff TEMPLIST $2 > $3
