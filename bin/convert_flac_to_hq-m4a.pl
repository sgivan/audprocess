#!/usr/bin/env perl 
#===============================================================================
#
#         FILE:  convert_flac_to_hq-m4a.pl
#
#        USAGE:  ./convert_flac_to_hq-m4a.pl  
#
#  DESCRIPTION:  Script to convert from lossless FLAC to
#                   a high-quality m4a compressed audio file
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
$outfile =~ s/\.flac/\.m4a/;

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

open(my $FFMPEG, "|-", "$ffmpeg -hide_banner -i \"$infile\" -c:a aac -strict -1 -b:a $sampleRate -osr 44.1K \"$outfile\"");

my @stdout = <$FFMPEG>;

close($FFMPEG);

say @stdout if ($verbose);
