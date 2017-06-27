#!/usr/bin/env python

## use: get_taxid_from_gi.py type('n' or 'p') GIlist output
## GIfile should be two items per line list of GI numbers (genbank) that you want the taxid info for
## example format: 
## contigname	gi|107294|accession|...
## databases on Sherlock were last updated May 14 2017. To update, download from ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdmp.zip [and get_taxid_prot.dmp]

import sys
import re

GI_file = open(sys.argv[2],'r')
output = open(sys.argv[3],'w')
output_missing = open('missing.txt','w') #file to store missing gi

names = "/scratch/PI/spalumbi/BLAST_db/names.dmp" #this file contains the tax id and the scientific name associated at that taxonomic level
nodes = "/scratch/PI/spalumbi/BLAST_db/nodes.dmp" #this file gives the current tax id and its parent tax id
if sys.argv[1]=='p':
	GI_TO_TAXID="/scratch/PI/spalumbi/BLAST_db/gi_taxid_prot.dmp" #this tab delim file contains 2 items: gi number, tax ID number
elif sys.argv[1]=='n':
	GI_TO_TAXID="/scratch/PI/spalumbi/BLAST_db/gi_taxid_nucl.dmp"
	sys.exit()

#dictionary creation for gi_taxid_prot
def make_dict(file):
	mydict={}
	data=open(file,'r')
	for line in data:
		## remove spaces, tabs, end returns
		line = line.strip('\n')
		items = line.split('\t')		
		if items[0] not in mydict:
			mydict[items[0]] = items[1] #the key is the first column, value is second column
	data.close()
	return mydict

#dictionary creation for names and nodes
def make_dict_names_nodes(file):
	mydict={}
	data=open(file,'r')
	for line in data:
		line = line.strip('\n')
		line = re.sub('[\t]', '', line)		
		items = line.split('|')	
		if items[0] not in mydict:
			mydict[items[0]] = items[1]
	data.close()
	return mydict

def get_name(ID):
	if ID in names_dict:
		return names_dict[str(ID)]
	else:
		return "missing" #in case something gets removed from database

def get_parent(ID):
	if ID in nodes_dict:
		return nodes_dict[str(ID)]
	else:
		return "1"

####
####  MAIN
####

names_dict = make_dict_names_nodes(names) #key is taxid, value is scientific name
nodes_dict = make_dict_names_nodes(nodes) #key is child taxid, value is parent taxid
gi_to_taxid_dict = make_dict(GI_TO_TAXID) #key is gi num, value is taxid

for line in GI_file:
	line = line.strip('\n') #remove the carriage return from each line in the file
	items=line.split('\t') #split all items on the line by tabs
	contig=items[0] #contig is first item in list
	
	gi_list=items[1].split('|') #GI is second item in list, split the info by the pipe 
	if len(gi_list) > 1:	
		gi = gi_list[1] # GInum is the second item in this new list
	else:
		output_missing.write(str(contig) + "\n") #output the contig to the missing file if the rest of the data is missing		
		continue
	
	if gi in gi_to_taxid_dict:
		original_taxid=gi_to_taxid_dict[gi] #original is species name
		working_taxid = original_taxid #placeholder for where we are in the taxonomic lineage
		lineage = get_name(working_taxid) #get taxonomic name for the current working taxid	
	else:
		output.write(str(contig) + '\t' + str(gi) + "\n") #output the whole lineage for that line		
		working_taxid = "1" #this is not needed before of the continue on the next line
		continue #without the continue here the next loop will be skipped but it will still try to do the output.write but will not have all the variables for it which will cause an error
		
	## loop through parent nodes until we get to root (node = 1)
	while working_taxid != "1" :
		parent_id = get_parent(working_taxid) #get parent taxID given current child taxID
		parent_name = get_name(parent_id) #look up ID number to get scientific name
		lineage = parent_name + "|" + lineage #place parent name into front of list that is pipe separated
		working_taxid = parent_id #replace workingid to move higher in lineage structure
	output.write(str(contig) + '\t' + str(gi) + '\t' + str(original_taxid) + "\t" + lineage + "\n") #output the whole lineage for that line	

print sys.getsizeof(gi_list)

GI_file.close()
output.close()	
output_missing.close()
