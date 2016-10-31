#!/usr/bin/perl

use warnings;
use strict;


# This is a script written by Megan Morikawa in 2015 that takes an the output fasta file from Trinity and creates a new fasta with only the longest isoform. 
# Usage perl LongestIsoformTrinity.pl file.fasta output.fasta

my ($input_file, $output_file) = @ARGV;

# Use dictionary to store key (isoform name) and values (contig length, sequence in same format as it was inputted)

# Read input file
# If it starts with >, extract what follows TRINITY_ [key], length of sequence [value[0]], header [value[1]], and sequence [value[2]]

# At end of file, sort keys, and print header then sequence (positions 1 and 2 of value array)

# Format of header
# >TRINITY_DN118274_c0_g1_i1 len=536 path=[7200:0-91 7201:92-535] [-1, 7200, 7201, -2]

my %fasta;

# Get length of file to be able to store last sequence of that file
my $filelength;
open(my $CHECK, "<", $input_file);
$filelength++ while <$CHECK>;
close $CHECK;

open(my $INPUT, "<", $input_file) or die "Cannot open $input_file\n";
open(my $OUTPUT, ">", $output_file) or die "Cannot create $output_file\n";
# Pop first character of line, check to see if it is >, if so, then extract information from header 
# Extract information by split, substring first element to unique identifier, substring length
# Check to see if in dictionary 
# If not, read sequence, store, and move to next header

# Binary for knowing when to store sequence
my $storeseq = 0;
# Empty array of sequence
my @sequence;
# Empty string of identifier
my $identifier = '';


while(defined(my $readline = <$INPUT>)){
  my $test = substr $readline, 0, 1;
  if ($. == $filelength){
  	# Store last sequence of file
 	  my @temp = @{$fasta{$identifier}}; 
 	  push @temp, [@sequence];  
 	  $fasta{$identifier} = \@temp;  	
  }
  if ($test eq ">"){
  	# We're in a header, end store sequence
  	$storeseq = 0;
   	if(length $identifier > 0){
   		#Store sequence to most recent key 
   		my @temp = @{$fasta{$identifier}}; # check expansion
   		push @temp, [@sequence];  
  #		print join("\n", @temp), "\n";
   		$fasta{$identifier} = \@temp;
   	}
  	@sequence = (); # reset sequence
  	chomp $readline;
  	# Evaluate header line
  	my @row = split(/\s/,$readline);
 	my $length = substr $row[1], 4, (length $row[1])-4; 
  	my @temp = split(/_/, $row[0]);
 	# Identifier is DN]d+_c\d_g\d
 	$identifier = $temp[1] . "_" . $temp[2] . "_" . $temp[3];
 	if (defined $fasta{$identifier}){
 		# Check to see if isoform is longer;
 		if($length > $fasta{$identifier}[0]){
 			# Store sequence
 			$storeseq = 1;
 			# Replace length & header
 			$fasta{$identifier} = [$length, $readline];
 		}
 	}else{
 		# Enter new key into dictionary & store sequence 
 		$fasta{$identifier} = [$length, $readline];
 		# Store sequence
 		$storeseq = 1;
 	}
  }elsif($storeseq = 1){
  	# Store sequence to preceeding header 	
  	# Build @sequence
  	push @sequence, $readline;
   }
}

foreach my $ids (sort keys %fasta){
	my $header = $fasta{$ids}[1];
	my @fasta = @{$fasta{$ids}[2]};
	print $OUTPUT $header, "\n", join('', @fasta);
  # For short name fasta
#  print $OUTPUT ">" , $ids, "\n", join('', @fasta);
}

