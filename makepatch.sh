#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    printf "Can't do anything with no input files, can I?\n"
    printf "Usage: $0 <original file> <new file>\n"
    exit 1
fi

diff -up $1 $2 > $1.patch
perl /usr/src/linux/scripts/cleanpatch $2.patch
perl /usr/src/linux/scripts/checkpatch.pl $2.patch
