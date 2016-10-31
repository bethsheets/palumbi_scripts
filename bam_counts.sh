#!/bin/bash

for i in "${@:2}"; do
    echo $i
    samtools view -c $i >> $1
done
