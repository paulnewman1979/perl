#!/bin/bash

file=$1

header=""
if [ "$3" != "" ]
then
    header=$3
fi

cat case/$file | \
    ./curl.sh 2>/dev/null \
    > result/$file
