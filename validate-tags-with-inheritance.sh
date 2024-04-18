#!/bin/bash

# VERIFY THAT EACH CHILD TAGGED VIDEO IS ALSO MOTHER TAGGED

INHERITANCE_DIR=rules/tags-inheritance
CATEGORIES_DIR=rules/tags-categories

GENERATION_DIR=generated
TAGS_DIR=$GENERATION_DIR/tags

echo
echo " --- [TAGS INHERITANCE VALIDATION] --- "

# For each mother tag's file
inheritanceErrorsCount=0
for inheritanceFile in $INHERITANCE_DIR/*; do

    # Get the mother tag from its file name
    motherTag=$(basename $inheritanceFile | cut -d "." -f 1)

    # Read its children tags
    while IFS= read -r childTag; do

        # $childTag is a kind of $motherTag

        if ! [[ -f $TAGS_DIR/$childTag.txt ]]; then

            echo {$childTag} not found amongst file names\' tags

        else

            # For each video tagged with a child tag
            while IFS= read -r childTaggedVideoName; do

                # $childTaggedVideoName is tagged with $childTag

                # If childTaggedVideoName is not in $TAGS_DIR/$motherTag file
                if ! grep -qr "^$childTaggedVideoName$" $TAGS_DIR/$motherTag.txt; then

                    echo $childTaggedVideoName is tagged with {$childTag} but not with {$motherTag}

                    ((inheritanceErrorsCount++))
                fi
            done < $TAGS_DIR/$childTag.txt
        fi
    done < $inheritanceFile
done

echo $inheritanceErrorsCount inheritance errors found
