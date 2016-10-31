#!/usr/bin/python

#usage: parse-assembly.py outfile assembly.fa goodcontigs.txt

#Pulls only good contigs (i.e. uniprot matches with environmental taxa removed) from your assembly and generates a fitlered assembly file

import sys
from Bio import SeqIO
OUT= open(sys.argv[1],'w')

assembly = open(sys.argv[2], 'r')
#make a list of good contig names
good_contigs = open(sys.argv[3],'r').read().split()
#make a list to store good contigs and their sequences from your assembly
keep = list()

for record in SeqIO.parse(assembly,"fasta"):
	if record.id in good_contigs:
		keep.append(record)
		
SeqIO.write(keep,OUT,'fasta')

