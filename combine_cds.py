#usage: python combine_coding.py input_cds_grepped_from_gff_then_gff2bed_awk_prepend_strand.fa out.fa
import sys
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.Alphabet import generic_dna
coding=SeqIO.parse(sys.argv[1],'fasta',generic_dna)
combined=dict()

for cds in coding:
    name=cds.id
    transcript=name.split('.cds')[0]
    if transcript in combined:
        combined[transcript]=combined[transcript]+cds.seq
    else:
        cds.id=transcript
        combined[transcript]=cds

final=dict()
for transcript, cds in combined.iteritems():
    if transcript[0]=='-':
        cds.seq=cds.seq.reverse_complement()
    cds.id=str(transcript)[1:]
    combined[transcript]=cds

OUT = open(sys.argv[2], "w")
SeqIO.write(combined.values(), OUT, "fasta")
OUT.close()
