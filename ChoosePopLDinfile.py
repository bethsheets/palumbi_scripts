# usage: python ChoosePopLDinfile.py SNPcoords.txt Population_GFE.in PopulationSNP_GFE.in
# SNPcoordinates.txt is a tab-delimited list of contig, snp, NewPos, which can be a subset of 
# SNPs in Population_GFE.in (make sure there’s no blank line at end of file). 
# This script will rename all contigs "Fake" and assign SNPs of interest the position in SNPcoords.txt
# Aryn Wilder, 6/6/16

import os, sys, random

targets=[]
chrpos=[]
infile=open(sys.argv[1],'r')
for line in infile:
	data=line.split('\t')
	targets.append(str(data[0]+':'+data[1]))
	chrpos.append(data[2].strip('\n'))
infile.close()

infile=open(sys.argv[2],'r')
outfile=open(sys.argv[3],'w')
header=infile.readline()
outfile.write(header)
for line in infile:
	data=line.split()
	if str(data[0]+':'+data[1]) in targets:
		idx=targets.index(str(data[0]+':'+data[1]))
		outfile.write('Fake\t'+str(chrpos[idx])+'\t'+'\t'.join([str(x) for x in data[2:]])+'\n')
infile.close()

