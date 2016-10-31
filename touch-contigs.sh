#!/bin/bash

while read p; do touch $2/${p}.snps.txt ; bgzip $2/${p}.snps.txt ; done < $1
