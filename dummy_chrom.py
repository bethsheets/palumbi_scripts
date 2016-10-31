#!/usr/bin/env python

# usage: dummy_chrom.py in out
# This script will rename all contigs "Dummy" and assign SNPs of interest escalating position with 100000 bases between contigs
# Aryn Wilder, 6/6/16
# Modified by Noah Rose 6/6/16

import os, sys, random
infile=open(sys.argv[1],'r')
outfile=open(sys.argv[2],'w')
header=infile.readline()
outfile.write(header)
prevcontig=''
offset=0
prevpos=-100000
for line in infile:
	data=line.split()
	currcontig=data[0]
	if prevcontig != currcontig:
		offset=100000+prevpos
	currpos=int(data[1])+offset
	outfile.write('Dummy\t'+str(currpos)+'\t'+'\t'.join([str(x) for x in data[2:]])+'\n')
	prevpos=currpos
	prevcontig=currcontig
infile.close()
outfile.close()

