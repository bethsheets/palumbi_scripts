#!/bin/bash

awk '{print $1,"blastx","CDS",$2+1,$3,".",$6,0,Parent="$4}' $1
