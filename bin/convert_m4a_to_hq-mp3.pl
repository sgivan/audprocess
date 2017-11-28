#!/usr/bin/env perl 
#===============================================================================
#
#         FILE:  convert_m4a_to_hq-mp3.pl
#
#        USAGE:  ./convert_m4a_to_hq-mp3.pl  
#
#  DESCRIPTION:  Script to convert from lossless m4a to
#                   a high-quality mp3 compressed audio file
#                   that is compatible with iTunes Match
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Dr. Scott A. Givan (SAG), sgivan@yahoo.com
#      COMPANY:  BWL Software
#      VERSION:  1.0
#      CREATED:  07/06/2016 08:56:42 PM
#     REVISION:  ---
#===============================================================================



use 5.010;      # Require at least Perl version 5.10
use autodie;
use Getopt::Long; # use GetOptions function to for CL args
use warnings;
use strict;

my ($debug,$verbose,$help,$infile,$b320,$b256,$sampleRate);

my $result = GetOptions(
    "debug"     =>  \$debug,
    "verbose"   =>  \$verbose,
    "help"      =>  \$help,
    "infile:s"  =>  \$infile,
    "b320"      =>  \$b320,
    "b256"      =>  \$b256,
);

if ($help) {
    help();
    exit(0);
}

chomp(my $ffmpeg = `which ffmpeg`);
$sampleRate = "320K";
$sampleRate = "256K" if ($b256);

if ($debug) {
    say "ffmpeg: '$ffmpeg'";
}

my $outfile = $infile;
$outfile =~ s/\.m4a/\.mp3/;

if ($debug) {
    say "infile: '$infile'";
    say "outfile: '$outfile'";
}

sub help {

say <<HELP;

    "debug"     =>  \$debug,
    "verbose"   =>  \$verbose,
    "help"      =>  \$help,
    "infile:s"  =>  \$infile,
    "b320"      =>  \$b320,
    "b256"      =>  \$b256,

HELP

}

if (1) {
  say "file: //$infile//";
  my $escaped = $infile;
  $escaped =~ s/\\//g;
  $escaped =~ s/(\W)/\\$1/g;
  say "escaped: '$escaped'";
  $infile = $escaped;
  $escaped = $outfile;
  $escaped =~ s/\\//g;
  $escaped =~ s/(\W)/\\$1/g;
  $outfile = $escaped;
}
#open(my $FFMPEG, "|-", "$ffmpeg -i \"$infile\" -c:a aac -strict -1 -b:a $sampleRate -osr 44.1K \"$outfile\"");
#open(my $FFMPEG, "|-", "$ffmpeg -hide_banner -i \'$infile\' -b:a $sampleRate -osr 44.1K \'$outfile\'");
open(my $FFMPEG, "|-", "$ffmpeg -hide_banner -i $infile -b:a $sampleRate -osr 44.1K $outfile");

my @stdout = <$FFMPEG>;

close($FFMPEG);

say @stdout if ($verbose);
