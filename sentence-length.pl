#!/usr/bin/perl

use strict;
use warnings;

my $file = "episodes/01.tex";
open (FILE,$file) or die "Cannot open FILE: $!\n";

my $TSentences = 0;
my $TWords = 0;
my $AvgSentenceLength = 0;

while(my $line = <FILE>)
{
    my @words = split(" ",$line);
    my $nwords = @words; #number of words in that line
    $TWords = $TWords+$nwords;
}

print "Total Words:\t\t$TWords\n";

close(FILE);
open (FILE2,$file) or die "Cannot open FILE2: $!\n";

while(my $ch = getc(FILE2))
{
    print $ch;
    if($ch eq "." or $ch eq "!" or $ch eq "?")
    {
        $TSentences++;
    }
}

$AvgSentenceLength = $TWords/$TSentences;

print "\nTotal sentences:\t$TSentences\n";
$AvgSentenceLength = sprintf("%.2f", $AvgSentenceLength);
print "\nAverage sentence length:$AvgSentenceLength\n";

exit(0);
