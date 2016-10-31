#!/usr/bin/perl

#to count # of times you have a unique filename: grep ">" yourfile.fa | perl /share/PI/spalumbi/scripts/histogram.pl | head -n



use warnings;
use strict;

my %hash;

while (defined (my $line = <>)) {
	chomp $line;
	$hash{$line}++;
}

sub byvalue { $hash{$b} <=> $hash{$a} }

foreach my $key (sort byvalue keys(%hash)) {
	print "$hash{$key} $key\n";
}
