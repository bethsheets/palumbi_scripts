#!/bin/bash

blast2bed $1
bed2gffCDS.sh $1.bed > $1.gff3
