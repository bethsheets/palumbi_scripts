#!/bin/bash 
# usage: inlist ref.bed out.bed

sed 's/\(^.*\)/\1\t/g' $1 > TEMPLIST
grep -Ff TEMPLIST $2 > $3
