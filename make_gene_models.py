#!/usr/bin/env python
## author: Bryan Barney
## date: June 26th, 2017
## script to subset a genome into the gene models present in a GFF file
## tab-delimited lists of genes and other information, in GFF Format:

## GFF format:
##	1:	sequencename (in our case, CHROM or contig name)
##	2:	source (maker or .)
##	3:	feature
##	4:	start base
##	5:	end base
##	6:	score
##	7:	strand (+/-)
##	8:	frame (0,1, or 2.... 0 means first base of feature is first base of codon)
##	9:	attribute
##	10:

## usage:   ./make_gene_models.py GFF_file genome_fasta 
## note: run through Palumbi lab anaconda version of python

import sys
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import IUPAC

GFF_file = open(sys.argv[1],'r')
genome_fasta = open(sys.argv[2],'r')

# create dictionary of genome from fasta file
scaffolds_dict = SeqIO.to_dict(SeqIO.parse(genome_fasta, "fasta"))
	
genome_fasta.close()

gene_models=[]
for line in GFF_file:
	line = line.strip()
	items = line.split('\t')
	# (gene_CHROM) format of A_gem genome fasta: adi_Scaffold#, format of gff gene IDs: scaf#
	# will need to convert searched name
	gff_seq_name = items[0]
	gene_CHROM = 'adi_Scaffold' + gff_seq_name[4:] 
	#print(gene_CHROM)

	gene_start = int(items[3])	## tab 4 (items[3]) = start base, tab 5 (items[4]) = end base
	gene_end = int(items[4])
	gene_name_list = items[8].split(';')
	gene_name_info = gene_name_list[0].split('=')
	gene_name = str(gene_name_info[1])
	print gene_name
	
	if gene_CHROM in scaffolds_dict:
		fasta = scaffolds_dict[gene_CHROM].seq
		newseq = fasta[(gene_start-5):(gene_end+5)]   ###### used 5 extra bases to make sure we capture start and stop of gene model... harmless
		myseq = SeqRecord(newseq,id=gene_name)

		gene_models.append(myseq)

SeqIO.write(gene_models, "genemodels.fasta", "fasta")

GFF_file.close()
