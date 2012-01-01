#!/bin/bash

GENERATION_DIR=generated
COUNTS_DIR=$GENERATION_DIR/tags-countings

echo
echo " --- [TAGS COUNT PRINTING] --- "
echo

if ! [[ -d $COUNTS_DIR ]]; then

    echo "$COUNTS_DIR dir not found."
    echo "Have you called show-statistics.sh (or count-apparitions.sh before) ?"
    exit 1
fi

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
