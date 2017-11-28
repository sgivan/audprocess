#!/bin/bash
#
# script to convert audio to files to
# Apple Lossless Audio Codec (ALAC)
# compatible with iTunes Match
# Output will be in m4a containers
#

$(mkdir -p ALAC)

for dir
do
    echo $dir
    oldfile=$dir
    #newfile=$(echo $dir | sed -E 's/(\w+)\.flac/\1.m4a/')
    newfile=$(echo $dir | sed -E 's/(.+)\.flac/\1.m4a/')
    #echo "oldfile: "${oldfile}
    #echo "newfile: "${newfile}
    #ls -l "${oldfile}"
    #rtn=$(ffmpeg -i "${oldfile}" -c:a alac -sample_fmt s16p -osr 44.1K "ALAC/${newfile}")
    rtn=$(ffmpeg -i "${oldfile}" -c:a alac -sample_fmt s16p -osr 44.1K "ALAC/${newfile}")
    # needs -sample_fmt and -osr to be compatible with iTunes music match
    # resulting file will be 16bit 44.1kHz
done


