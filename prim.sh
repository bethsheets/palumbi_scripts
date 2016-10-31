#!/bin/bash
#SBATCH --mem=8000
vcfallelicprimitives $1 | vcffixup -  > $2
