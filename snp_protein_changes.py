#!/usr/bin/env python
#usage: coding.py vcf ref.fa orfpredictor_headers.txt OUT
#to get orfpredictor_headers.txt run orfpredictor on ref.fa
#	then grep ">" orf.pep | sed 's/>//g' | sed 's/+//g' > orfpredictor_headers.txt


import sys
import csv
from Bio import SeqIO 
from Bio.Seq import Seq
from Bio.Alphabet import generic_dna
coding=SeqIO.parse(sys.argv[2],'fasta',generic_dna)
transcripts=SeqIO.to_dict(coding)
OUTFILE='CHROM,POS,ID,REF,ALT,REFprot,ALTprot,EFFECT,CPOS'

frames=dict()
with open(sys.argv[3],'r') as framefile:
	reader = csv.reader(framefile,delimiter='\t')
	for contig,frame,start,end in reader:
		frames[contig]=(frame,start,end)

with open(sys.argv[1],'rU') as vcffile:
	snps = csv.reader(vcffile,delimiter='\t',quotechar='"')
	for snp in snps:
		if snp[0].startswith('#'):
			continue
		transcript=transcripts[snp[0]]
		if not snp[0] in frames:
			OUTFILE=OUTFILE+'\n'+','.join(snp[0:5])+',NA,NA,noORF,NA'
			continue
		frame=frames[snp[0]]
		pos=int(snp[1])-1

		tstart=int(frame[1])-1
		tstop=int(frame[2])
		altbase=Seq(snp[4],generic_dna)
		framesign=1
		if int(frame[0])<0:
			transcript=transcript.reverse_complement()
			pos=len(transcript)-pos-1
			altbase=altbase.reverse_complement()
			framesign=-1



		if pos < tstart or pos >= tstop:
			OUTFILE=OUTFILE+'\n'+','.join(snp[0:5])+',NA,NA,pUTR,NA'
			continue

		transcript=transcript[tstart:tstop]
		pos=pos-tstart
		cpos=pos%3
		cstart=pos-cpos
		cstop=pos-cpos+3
		codon=transcript[cstart:cstop]

		ref=codon.seq.translate()
		altcodon=codon[0:cpos]+altbase+codon[cpos+1:3]
		alt=altcodon.seq.translate()
		effect='S'
		if ref != alt:
			effect='NS'
		OUTFILE=OUTFILE+'\n'+','.join(snp[0:5])+','+str(ref)+','+str(alt)+','+effect+','+str((1+cpos)*framesign)

with open(sys.argv[4],'w') as f:
	f.write(OUTFILE)
		
