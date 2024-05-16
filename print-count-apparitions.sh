#!/bin/bash

GENERATION_DIR=generated
COUNTS_DIR=$GENERATION_DIR/tags-countings

echo
echo " --- [TAGS COUNT PRINTING] --- "
echo

tagsCountsArray=()
for tagsApparitionCountPath in $COUNTS_DIR/*; do

    tagsCount=$(basename $tagsApparitionCountPath | cut -d "-" -f 1)
    tagsCountsArray+=("$tagsCount")
done

IFS=$'\n' sortedTagsCountsArray=($(sort -n <<< "${tagsCountsArray[*]}")); unset IFS

for tagsCount in ${sortedTagsCountsArray[@]}; do

    echo
    echo -Tags with $tagsCount apparitions:
    tr '\n' ' ' < $COUNTS_DIR/$tagsCount-apparitions.txt
    echo
done
