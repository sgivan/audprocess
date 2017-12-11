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

my ($debug,$verbose,$help,$infile,$b320,$b256,$b128,$sampleRate,$sampleRateInt,$lowerbitrate);

my $result = GetOptions(
    "debug"     =>  \$debug,
    "verbose"   =>  \$verbose,
    "help"      =>  \$help,
    "infile:s"  =>  \$infile,
    "b320"      =>  \$b320,
    "b256"      =>  \$b256,
    "b128"      =>  \$b128,
    "lowerbitrate"  =>  \$lowerbitrate,
);

if ($help) {
    help();
    exit(0);
}

chomp(my $ffmpeg = `which ffmpeg`);
chomp(my $ffprobe = `which ffprobe`);
$sampleRate = "320K";
$sampleRateInt = 320000;
if ($b256) {
  $sampleRate = "256K";
  $sampleRateInt = 256000;
} elsif ($b128) {
  $sampleRate = "128K";
  $sampleRateInt = 128000;
}

if ($debug) {
    say "ffmpeg: '$ffmpeg'";
    say "ffprobe:  '$ffprobe'";
}

my $outfile = $infile;
$outfile =~ s/\.m4a/\.mp3/;

if ($debug) {
    say "infile: '$infile'";
    say "outfile: '$outfile'";
}

sub help {

say <<HELP;

    --debug
    --verbose
    --help
    --infile:s
    --b320
    --b256
    --b128
    --lowerbitrate

HELP

}

my ($infile_esc, $outfile_esc) = ();
open (my $FAIL, ">>", "fails.txt") or die ("can't open fails.txt");
if (1) {
  say "file: //$infile//" if ($debug);
  my $escaped = $infile;
  $escaped =~ s/\\//g;
  $escaped =~ s/(\W)/\\$1/g;
  say "escaped: '$escaped'" if ($debug);
  $infile_esc = $escaped;
  $escaped = $outfile;
  $escaped =~ s/\\//g;
  $escaped =~ s/(\W)/\\$1/g;
  $outfile_esc = $escaped;
}

if ($debug) {
  say "escaped file paths:";
  say "infile: '$infile_esc'";
  say "outfile: '$outfile_esc'";
}

my $curr_bitrate = 0;
print "\n\nchecking output file '$outfile'\n\n" if ($debug);
if (-e $outfile) {
  #
  #ffprobe -i out.mp3 -v quiet -show_entries stream=bit_rate -of default=noprint_wrappers=1
  if ($debug) {
    say "output file exists";
    say "running command: '$ffprobe -i $outfile_esc -v quiet -show_entries stream=bit_rate -of default=noprint_wrappers=1'";
  }

  open(my $FFPROBE, "-|", "$ffprobe -i $outfile_esc -v quiet -show_entries stream=bit_rate -of default=noprint_wrappers=1");
  my $stdout = <$FFPROBE>;
  #close($FFPROBE);
  eval { close($FFPROBE) };
  if ($@) {
    warn "Error closing ffprobe: $@";
    print $FAIL "Error closing ffprobe: $@.";
    print $FAIL "$ffprobe -i $outfile_esc -v quiet -show_entries stream=bit_rate -of default=noprint_wrappers=1\n\n";
  }
  
  say "stdout: '$stdout'" if ($debug);
  if ($stdout =~ /bit_rate=(\d+)/) {
    $curr_bitrate = $1;
  }
  if ($debug) {
    say "$outfile current bit rate: '$curr_bitrate'";
  }
}
if ($lowerbitrate && $curr_bitrate && $curr_bitrate <= $sampleRateInt) {
  say "not converting file since current bit rate ($curr_bitrate) is <= $sampleRateInt" if ($verbose);
  exit(0);
}
open(my $FFMPEG, "-|", "$ffmpeg -y -hide_banner -i $infile_esc -b:a $sampleRate -osr 44.1K -vn $outfile_esc");

my @stdout = <$FFMPEG>;

eval { close($FFMPEG) };
if ($@) {
  warn "Error closing ffprobe: $@";
  print $FAIL "Error closing ffprobe: $@.";
  print $FAIL "$ffmpeg -y -hide_banner -i $infile_esc -b:a $sampleRate -osr 44.1K $outfile_esc";
}

say @stdout if ($verbose);
