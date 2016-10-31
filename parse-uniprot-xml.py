#!/usr/bin/env python

import urllib
import sys
import xml.etree.ElementTree as ET
from Bio.Blast import NCBIXML
#Usage, parses any number of xml files and creates a txt outfile with the uniprot gene name, taxonomic tree, etc
#usage: python parse-uniprot-xml.py outfile.txt *.blast.out
OUT = open(sys.argv[1], 'w')


OUT.write("QueryName\tUniprot\tDescription\tQueryLength\tAlignmentLength\tQueryStart\tQueryEnd\tHspExpect\tLineage\tGO")
for xml_file in sys.argv[2:]:
	result_handle = open(xml_file)
	blast_records = NCBIXML.parse(result_handle)
	for rec in blast_records:
		for alignment in rec.alignments:
				for hsp in alignment.hsps:
					linstr=''
					gostr=''
					description=''
					
					#get the best hit and download the uniprot xml entry for it
					match=str(alignment.title)
					uniprot=match.split('|')[3]
					unixml = urllib.urlopen('http://www.uniprot.org/uniprot/'+uniprot+'.xml')
					
					#this try/except block handles errors that arise when uniprot submissions are out of date
					#it will parse your blast script and leave lineage, go, and description blank 
					try:	
						tree = ET.parse(unixml)
					except ET.ParseError:
						OUT.write('\n'+ str(rec.query) + '\t'  + str(uniprot) + '\t' + str(description) + '\t' + str(rec.query_length) + '\t' + str(hsp.align_length) + '\t' + str(hsp.query_start) + '\t' + str(hsp.query_end)  + '\t' + str(hsp.expect) + '\t' + str(linstr)+ '\t' + str(gostr))
						continue						
					root = tree.getroot()
					entry = root.find('{http://uniprot.org/uniprot}entry')
					protein = entry.find('{http://uniprot.org/uniprot}protein')
					name = protein.find('{http://uniprot.org/uniprot}recommendedName')
					if name is None:
						name = protein.find('{http://uniprot.org/uniprot}submittedName')
					description = name.findtext('{http://uniprot.org/uniprot}fullName')
					organism = entry.find('{http://uniprot.org/uniprot}organism')
					lineage = organism.find('{http://uniprot.org/uniprot}lineage')
						
					#get entire taxonomic tree in delimited list
					for taxon in lineage.findall('{http://uniprot.org/uniprot}taxon'):
						linstr=linstr+taxon.text+';'
					#get each GO term in a semicolon delimited list
					for ref in entry.findall('{http://uniprot.org/uniprot}dbReference'):
						if ref.get('type') == 'GO':
							gostr=gostr+ref.get('id')+';'
							
				
					#### writes outfile with every character of interest
					OUT.write('\n'+ str(rec.query) + '\t'  + str(uniprot) + '\t' + str(description) + '\t' + str(rec.query_length) + '\t' + str(hsp.align_length) + '\t' + str(hsp.query_start) + '\t' + str(hsp.query_end)  + '\t' + str(hsp.expect) + '\t' + str(linstr)+ '\t' + str(gostr))

OUT.close()
