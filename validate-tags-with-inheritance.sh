#!/bin/bash

INHERITANCE_DIR=tags-inheritance
CATEGORIES_DIR=tags-categories

GENERATION_DIR=generated
TAGS_DIR=$GENERATION_DIR/tags

echo
echo " --- [TAGS INHERITANCE VALIDATION] --- "

# For each mother tag's file
for inheritanceFile in $INHERITANCE_DIR/*; do

    # Get the mother tag from its file name
    motherTag=$(basename $inheritanceFile | cut -d "." -f 1)

    # Read its children tags
    while read childTag; do

        # $childTag is a kind of $motherTag

        # For each video tagged with a child tag
        while read childTaggedVideoName; do

            # $childTaggedVideoName is tagged with $childTag

            # If childTaggedVideoName is not in $TAGS_DIR/$motherTag file
            if ! grep -qr "^$childTaggedVideoName$" $TAGS_DIR/$motherTag.txt; then

                echo $childTaggedVideoName is tagged with {$childTag} but not with {$motherTag}
            fi
        done < $TAGS_DIR/$childTag.txt
    done < $inheritanceFile
done