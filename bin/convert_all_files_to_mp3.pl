#!/usr/bin/env perl 
#===============================================================================
#
#         FILE:  convert_all_files_to_mp3.pl
#
#        USAGE:  ./convert_all_files_to_mp3.pl  
#
#  DESCRIPTION:  Perl script to convert all files in a directory to mp3
#                   using convert_to_mp3.pl script.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Dr. Scott A. Givan (SAG), sgivan@yahoo.com
#      COMPANY:  BWL Software
#      VERSION:  1.0
#      CREATED:  11/05/2015 08:54:55 AM
#     REVISION:  ---
#===============================================================================



use 5.010;      # Require at least Perl version 5.10
use autodie;
use Getopt::Long; # use GetOptions function to for CL args
use warnings;
use strict;

my ($debug,$verbose,$help,$file_type,$album_artist,$album_title,$preset);

my $result = GetOptions(
    "debug"     =>  \$debug,
    "verbose"   =>  \$verbose,
    "help"      =>  \$help,
    "type:s"    =>  \$file_type,
    "aartist:s" =>  \$album_artist,
    "atitle:s"  =>  \$album_title,
    "preset:s"  =>  \$preset,
);

$file_type = 'wav' unless ($file_type);
$album_artist = 'ablum artist' unless ($album_artist);
$album_title = 'album title' unless ($album_title);

my $convert_script = "$ENV{HOME}/projects/audprocess/bin/convert_to_mp3.pl";

if ($help) {
    help();
    exit(0);
}

opendir(my $dirh,'.');

for my $file ( grep(/.+\.$file_type$/, readdir($dirh)) ) {
#    say $file;
    if (!$preset) {
        open(CONV,"-|","$convert_script --infile '$file' --aartist '$album_artist' --atitle '$album_title' --informat $file_type");
    } else { 
        open(CONV,"-|","$convert_script --preset $preset --infile '$file' --aartist '$album_artist' --atitle '$album_title' --informat $file_type");
    }

    my @stdout = <CONV>;

    close(CONV);

    say @stdout;
}

closedir($dirh);

sub help {

say <<HELP;

    "debug"     =>  \$debug,
    "verbose"   =>  \$verbose,
    "help"      =>  \$help,
    "type:s"    =>  \$file_type,
    "aartist:s" =>  \$album_artist,
    "atitle:s"  =>  \$album_title,
    "preset:s"  =>  \$preset,

HELP

}

