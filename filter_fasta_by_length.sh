#!/bin/bash

awk -v fastalen=$2 '!/^>/ { next } { getline seq } length(seq) >= fastalen { print $0 "\n" seq }' $1 > $3
