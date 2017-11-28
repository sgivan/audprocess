#!/bin/bash

for dir
do
    echo $dir
    newfile=$(echo $dir | sed -r 's/\..*/\.mp3/')
    echo $newfile
    ffmpeg -i "$dir" "$newfile"
done


