#!/bin/bash

for dir
do
    echo "oldfile: "$dir
    newfile=$(echo "$dir" | sed -r 's/\..*/\.flac/')
    echo "newfile:" $newfile
    #lame --preset studio "$dir" "$newfile"
    ffmpeg -i "$dir" "$newfile"
done


