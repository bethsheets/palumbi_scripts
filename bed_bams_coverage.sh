#!/bin/bash

for i in "${@:2}"; do
    echo $i
    bedtools coverage -abam $i -b $1 >> $1.coverage
done
