#!/bin/bash

grep "\#\|MISSENSE\|SILENT" $1 | vcf2tsv | cut -f 1,2,4,5,18 > $2
