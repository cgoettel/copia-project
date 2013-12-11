#!/usr/bin/perl

use strict;
use warnings;

my $DEBUG = 0;

open OUT, ">copia-project.tex" or die "Failed to open OUT: $!\n";

print OUT "% DO NOT EDIT THIS FILE. IT IS AUTO-GENERATED FROM generate-tex.pl. RUN `make`.\n";
print OUT "\\documentclass[11pt]{article}\n";
print OUT "\\usepackage[margin=1in]{geometry}\n\n";
print OUT "\\usepackage{pdfpages}\n";
print OUT "\\usepackage{fontspec}\n";
print OUT "\\setmainfont[BoldFont={HoeflerText-Bold},ItalicFont={Hoefler Text Italic},BoldItalicFont={Hoefler Text Black Italic}]{Hoefler Text}\n\n";
print OUT "\\begin{document}\n";

# add_most_recent_episode();
add_all();

print OUT "\\end{document}\n";

close OUT;

# Run through one episode and put everything in its place.
sub add_most_recent_episode
{
    # Run through episodes directory and add every number to an array.
    my @episode_numbers = ();
    opendir( EPISODES, "episodes" ) or die "Cannot open EPISODES: $!\n";
    my @files = sort readdir(EPISODES);
    my $current_file = "";
    while ( $current_file = shift @files )
    {
        next if ( $current_file =~ /^\./ );
        $current_file =~ s/^([0-9]+).*$/$1/g;
        push @episode_numbers, $current_file;
    }
    closedir EPISODES;
    my @sorted_episode_numbers = sort @episode_numbers;
    my $episode_name = pop @sorted_episode_numbers;
    
    # Grab the name of the current file.
    my ($forward, $afterthought) = $episode_name;
    # Append z and a to the respective variables.
    $forward .= "-a.tex";
    $episode_name .= ".tex";
    
    my $word_count = 0;
    $word_count = `wc -w episodes/$episode_name`;
    my $sentence_length = sentence_length($episode_name);
    print OUT "~\n\n\\textbf{\\input{episodes/$forward}}\n\n";
    print OUT "\\textbf{Word count: " . substr($word_count,0,3) . "}\n\n";
    print OUT "\\textbf{Average sentence length: " . $sentence_length . "}\n\n~\n\n";
    print OUT "\\input{episodes/$episode_name}\n\n";
}

# Run through each of the episodes. Count the number of words in each file. Print that number plus the contents of the file.
sub add_all
{
    opendir EPISODES, "episodes" or die "Cannot open EPISODES: $!\n";
    my @files = sort readdir(EPISODES);
    my $current_file = "";
    my $counter = 0;
    my $total_word_count = 332; # This is the word count for the ACM document which won't be read in during processing.
    while ( $current_file = shift @files )
    {
        next if ( $current_file =~ /^\./ );
        my $word_count = 0;
        $word_count = `wc -w episodes/$current_file`;
        $word_count = substr($word_count,0,3);
        $total_word_count += $word_count;
        
        # If the current file is one of the "#-a.tex" files, print it in bold and go to the next file.
        if ( $current_file =~ /^08-a.tex$/ )
        {
            # Include ACM style document. It's number 7 and needs to go before 8.
            print OUT "\\includepdf[pages={-}]{7-acm/acm.pdf}\n\n";
            $counter+=2; # I seriously don't know why this works.
            print OUT "\\textbf{Episode $counter}\n\n";
            next;
        }
        elsif ( $current_file =~ /^[0-9]+-a.tex$/ )
        {
            # Bold the text in these files.
            $counter++;
            print OUT "\\textbf{Episode $counter}\n\n";
            print OUT "\\textbf{\\input{episodes/$current_file}}\n\n";
            next;
        }
        elsif ( $current_file =~ /^[0-9]+.tex$/ )
        {
            my $sentence_length = sentence_length($current_file);
            # Print the word count (bolded) and then the episode.
            print OUT "\\textbf{Word count: " . substr($word_count,0,3) . "}\n\n";
            print OUT "\\textbf{Average sentence length: " . $sentence_length . "}\n\n~\n\n";
            print OUT "\\input{episodes/$current_file}\n\n~\n\n";
            print OUT "\\clearpage\n\n";
            next;
        }
    }
    closedir EPISODES;
    
    print OUT "Total word count: $total_word_count" if $DEBUG;
}

sub sentence_length
{
    my $file = shift;
    open FILE, "<episodes/$file" or die "Failed to open FILE: $!\n";
    
    my $total_sentences = 0;
    my $total_words = 0;
    my $average_sentence_length = 0;
    
    while( my $line = <FILE> )
    {
        my @words = split(" ",$line);
        my $number_of_words = @words;
        $total_words = $total_words+$number_of_words;
    }
    
    close(FILE);
    open FILE2, "<episodes/$file" or die "Cannot open FILE2: $!\n";
    
    while( my $ch = getc(FILE2) )
    {
        if( $ch eq "." or $ch eq "!" or $ch eq "?" )
        {
            $total_sentences++;
        }
    }
    
    $average_sentence_length = $total_words/$total_sentences;
    $average_sentence_length = sprintf("%.1f", $average_sentence_length); # Round
    return $average_sentence_length;
}