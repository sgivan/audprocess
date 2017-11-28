#!/bin/bash

for file in *.flac
do
    echo "$file"
    /mnt/home/sgivan/projects/audprocess/bin/convert_flac_to_hq-mp3.pl --infile "$file"
done


