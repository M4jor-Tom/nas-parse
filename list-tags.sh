#!/bin/bash

GENERATION_DIR=generated
VALID_NAMES_FILE=$GENERATION_DIR/valid-base-names.txt
TAGS_DIR=$GENERATION_DIR/tags

rm -rf $TAGS_DIR
mkdir -p $TAGS_DIR

# Iterating through valid files names
while read validBaseName; do

    # Counting how many tags has a video
    tagsCount=$(echo $validBaseName | grep -o '{' | wc -l)

    # the offset to add for the cut command getting the tag's text
    cutOffset=2

    lastTagIndex=$(($tagsCount+$cutOffset))
    for i in $(seq $cutOffset $lastTagIndex); do
        
        tagWithClosingBrace=$(echo $validBaseName | grep -Eo '(\{(\w+)\})+' | cut -d "{" -f $i)
        tag="${tagWithClosingBrace%?}"

        if ! [[ $tag == "" ]]; then

            echo $validBaseName >> $TAGS_DIR/$tag.txt
        fi
    done;
done < $VALID_NAMES_FILE
