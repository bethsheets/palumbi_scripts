#!/bin/bash

srun fastx_quality_stats -Q33 -i $1 -o $1.qualstats.txt
