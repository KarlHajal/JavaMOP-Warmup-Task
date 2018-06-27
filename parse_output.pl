#!/usr/bin/perl

use strict;
use warnings;


# The script expects the mvn test output file name to be provided as an argument
my $input_file =  $ARGV[0];

(my $filename = $input_file) =~ s/\.[^.]+$//; #Extract the filename without the extension

open (FILE, $input_file);
open (my $OUTPUT_FILE, '>', $filename . '.csv') or die "Could not open file " . $filename . ".csv $!";

print $OUTPUT_FILE "Specification, Line, Documentation, Message\n"; #Column names

my %lines; #Hash that will be used to check if a violation has already been printed
while(<FILE>) {
  chomp;
  my $line = "$_"; #Current line 
  if ("$line" =~ /^Specification.*/) { #Check if the line starts with 'Specification', which indicates that it lists a violation
    my @values = split(' ', $line);
    if (not $lines{$line}++){ #Check if the violation has already been printed before
      # The following line abuses the fact that, in the specs being used, the format is the same for all violations listed
      print $OUTPUT_FILE @values[1] . ", " . substr (@values[7], 0, -1) . ", " . @values[16] . ", " . substr (<FILE>,0,-1) . "\n";
    }  
  }
}
close(FILE);
exit;
