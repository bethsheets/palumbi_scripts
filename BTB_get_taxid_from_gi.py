#!/usr/bin/env python

## use:   BTB_get_taxid_from_gi.py type('n' or 'p') GIlist output
## GIfile should be two items per line list of GI numbers (genbank) that you want the taxid info for
## example format: (don't put header in your input file)
## NAME			GI_num
## contigname	gi|107294|accession|whatevs
## contigname	gi|93912990|accession|whatevs
## etc....

import sys

GI_file = open(sys.argv[2],'r')
output = open(sys.argv[3],'w')
names = "/scratch/PI/spalumbi/BLAST_db/names.dmp"
nodes = "/scratch/PI/spalumbi/BLAST_db/nodes.dmp"

if sys.argv[1]=='p':
	GI_TO_TAXID="/scratch/PI/spalumbi/BLAST_db/gi_taxid_prot.dmp"
elif sys.argv[1]=='n':
	GI_TO_TAXID="/scratch/PI/spalumbi/BLAST_db/gi_taxid_nucl.dmp"
else:
	print "check your command line, enter p for protein or n for nucleotide databases\n"
	sys.exit()


def make_dict(file):
	mydict={}
	data=open(file,'r')
	for line in data:
		## remove spaces, tabs, end returns
		line = line.strip('\n')
		items = line.split('\t')
		mydict[items[0]] = items[1]
	data.close()
	return mydict

def get_name(ID):
	if ID in names_dict:
		return names_dict[str(ID)]
	else:
		return "missing"

def get_parent(ID):
	if ID in nodes_dict:
		return nodes_dict[str(ID)]
	else:
		return "1"

####
####  MAIN
####

gi_to_taxid_dict = make_dict(GI_TO_TAXID)
names_dict = make_dict(names)
nodes_dict = make_dict(nodes)


for line in GI_file:
	line = line.strip()
	items=line.split('\t')
	contig=items[0]
	gi_list=items[1].split('|')
	gi = gi_list[1]
	original_taxid=gi_to_taxid[gi]
	
	working_taxid = original_taxid

	lineage = get_name(original_taxid)

	## loop through parent nodes until we get to root (node = 1)
	while working_taxid != "1" :
		parent_id = get_parent(working_taxid)
		parent_name = get_name(parent_id)
		lineage = parent_name + "|" + lineage
		working_taxid = parent_id
	output.write(str(contig) + '\t' + str(gi) + '\t' + str(original_taxid) + "\t" + lineage + "\n")	

GI_file.close()
output.close()	
