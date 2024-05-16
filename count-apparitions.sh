#!/bin/bash

GENERATION_DIR=generated
TAGS_DIR=$GENERATION_DIR/tags
COUNTS_DIR=$GENERATION_DIR/tags-countings

MINIMUM_APPARITIONS=$(cat statistics-parameters/minimum-apparitions.txt)

rm -rf $COUNTS_DIR
mkdir -p $COUNTS_DIR

echo
echo " --- [TAGS COUNTING] --- "
echo

tagsCount=$(ls -l $TAGS_DIR | wc -l | cut -d " " -f 1)
tagsIndex=0
for tagPath in $TAGS_DIR/*; do

    tagApparitions=$(wc -l $tagPath | cut -d " " -f 1)

    if [[ $tagApparitions -ge $MINIMUM_APPARITIONS ]]; then

        tag=$(basename $tagPath | cut -d "." -f 1)
        echo $tag >> ${COUNTS_DIR}/${tagApparitions}-apparitions.txt
    fi

    ((tagsIndex++))

    echo $tagsIndex / $tagsCount
    echo -e "\033[2A"
done

echo Counting finished. Find apparitions at $COUNTS_DIR
echo
