#!/usr/bin/env perl 
#===============================================================================
#
#         FILE:  convert_to_mp3.pl
#
#        USAGE:  ./convert_to_mp3.pl  
#
#  DESCRIPTION:  Script to convert input audio file to mp3.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Dr. Scott A. Givan (SAG), sgivan@yahoo.com
#      COMPANY:  BWL Software
#      VERSION:  1.0
#      CREATED:  10/28/2015 10:50:10 AM
#     REVISION:  ---
#===============================================================================



use 5.010;      # Require at least Perl version 5.10
use autodie;
use Getopt::Long; # use GetOptions function to for CL args
use warnings;
use strict;
#use Audio::TagLib;

my ($debug,$verbose,$help,$infile,$informat,$outformat,$album_artist,$album_title,$album_track,$encode_quality,$bitrate,$preset,$codec);

my $result = GetOptions(
    "debug"         =>  \$debug,
    "verbose"       =>  \$verbose,
    "help"          =>  \$help,
    "infile:s"      =>  \$infile,
    "informat:s"    =>  \$informat, # I need this to munge new file name
#    "outformat:s"   =>  \$outformat,# probably don't need b/c lame gets this from file suffix
    "aartist:s"     =>  \$album_artist,
    "atitle:s"      =>  \$album_title,
    "atrack:s"      =>  \$album_track,
    "preset:s"            =>  \$preset,
    "bitrate:i"     =>  \$bitrate,
    "codec:s"       =>  \$codec,

);

chomp(my $lame = `which lame`);
$infile ||= 'infile.wav';
$informat ||= 'wav';

my $outfile = $infile;

$outfile =~ s/$informat/mp3/;

if ($debug) {
    say "lame binary = '$lame'";
    say "outfile = '$outfile'";
}

if ($help) {
    help();
    exit(0);
}

if (-e $infile) {

    if ($infile =~ /Track(\d+)/) {
        $album_track = $1;
    } elsif ($infile =~ /(\d+)\..+/) {
        $album_track = $1;
    } elsif ($infile =~ /.*(\d+)\..+/) {
        $album_track = $1;
    }


    if ($verbose) {
        say "converting $infile to $outfile";
        say "artist: '$album_artist'" if ($album_artist);
        say "title: '$album_title'" if ($album_title);
        say "track: '$album_track'" if ($album_track);
        say "quality = '$encode_quality'";
    }

    if (!$preset) {
        open(LAME,"-|","$lame --vbr-new --preset standard --ta '$album_artist' --tl '$album_title' --tn $album_track $infile $outfile");
#    } elsif ($bitrate) {
#        open(LAME,"-|","$lame"); 
    } else {
        open(LAME,"-|","$lame --vbr-new --preset $preset --ta '$album_artist' --tl '$album_title' --tn $album_track '$infile' '$outfile'");
    }

    my @lamestdout = <LAME>;

    if (!close(LAME)) {
        warn("can't close $lame properly: $!");
    }

    say @lamestdout;

} else {

    say "$infile doesn't exist in this directory";

}

#        $(lame -q 2 --ta XTC --tl 'The Big Express' --tn $track "$file" "${file_root}.mp3")


sub help {

say <<HELP;

    "debug"         =>  \$debug,
    "verbose"       =>  \$verbose,
    "help"          =>  \$help,
    "infile:s"      =>  \$infile,
    "informat:s"    =>  \$informat, # I need this to munge new file name
#    "outformat:s"   =>  \$outformat,# probably don't need b/c lame gets this from file suffix
    "aartist:s"     =>  \$album_artist,
    "atitle:s"      =>  \$album_title,
    "atrack:s"      =>  \$album_track,
    "preset:s"            =>  \$preset,

HELP

}

