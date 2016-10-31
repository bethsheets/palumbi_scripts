#!/bin/bash

vcffilter -f "QUAL > 30 & AC > 1" $1 | vcfallelicprimitives | vcffixup - > $2
