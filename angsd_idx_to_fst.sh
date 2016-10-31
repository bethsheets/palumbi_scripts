#!/bin/bash

BASE=$(basename $1 .fst.idx)
realSFS fst print $1 | awk '{ print $0 "\t" $3 / $4 }'  > $BASE.fst.txt
