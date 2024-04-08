#!/bin/bash

# VALIDATE THAT EVERY MANDATORY CATEGORY IS REPRESENTED BY A TAG IN EACH NAME

GENERATION_DIR=generated
TAGGED_BASE_NAMES_FILE=$GENERATION_DIR/valid-base-names.txt
TAGS_DIR=$GENERATION_DIR/tags
MANDATORY_CATEGORIES_FILE=mandatory-categories.txt
CATEGORIES_DIR=tags-categories

echo
echo " --- [CATEGORIES REPRESENTATION VALIDATION] --- "

# For each tagged file name
while read taggedFileName; do

    # For each tag of the file name
    while read mandatoryCategory; do

        # Each possible tag which the mandatoryCategory represents
        possibleMandatoryTagsNames=$(cat $CATEGORIES_DIR/$mandatoryCategory.txt)

        # Get the file names representing tags of the file
        fileTagFileNames=$(grep -lr "$taggedFileName" "$TAGS_DIR")

        # For each tag file name representing the file
        for fileTagFileName in $fileTagFileNames; do

            # Get the tag name
            fileTag=$(basename $fileTagFileName | cut -d "." -f 1)

            # If the tag name is a possible mandatoryCategory tag name 
            if [[ " ${possibleMandatoryTagsNames[*]} " =~ [[:space:]]${fileTag}[[:space:]] ]]; then

                echo $fileTag satisfies $mandatoryCategory
            fi
        done
    done < $MANDATORY_CATEGORIES_FILE
done < $TAGGED_BASE_NAMES_FILE
