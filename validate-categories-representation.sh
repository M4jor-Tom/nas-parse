#!/bin/bash

# VALIDATE THAT EVERY MANDATORY CATEGORY IS REPRESENTED BY A TAG IN EACH NAME

GENERATION_DIR=generated
TAGGED_BASE_NAMES_FILE=$GENERATION_DIR/valid-base-names.txt
TAGS_DIR=$GENERATION_DIR/tags
MANDATORY_CATEGORIES_FILE=rules/mandatory-categories.txt
CATEGORIES_DIR=rules/tags-categories

echo
echo " --- [CATEGORIES REPRESENTATION VALIDATION] --- "
echo Mandatory categories:
cat $MANDATORY_CATEGORIES_FILE

# For each tagged file name
invalidTaggedFileNameCount=0
while IFS= read -r taggedFileName; do

    taggedFileNameIsInvalid=false

    # For each tag of the file name
    while IFS= read -r mandatoryCategory; do

        # Each possible tag which the mandatoryCategory represents
        possibleMandatoryTagsNames=$(cat $CATEGORIES_DIR/$mandatoryCategory.txt)

        # Get the file names representing tags of the file
        fileTagFileNames=$(grep -lr "$taggedFileName" "$TAGS_DIR")

        mandatoryCategoryIsRespected=false

        # For each tag file name representing the file
        for fileTagFileName in $fileTagFileNames; do

            # Get the tag name
            fileTag=$(basename $fileTagFileName | cut -d "." -f 1)

            # If the tag name is a possible mandatoryCategory tag name 
            if [[ " ${possibleMandatoryTagsNames[*]} " =~ [[:space:]]${fileTag}[[:space:]] ]]; then

                # echo $fileTag satisfies $mandatoryCategory
                mandatoryCategoryIsRespected=true
            fi
        done

        if [[ $mandatoryCategoryIsRespected = false ]]; then

            taggedFileNameIsInvalid=true
            echo $taggedFileName does not include [$mandatoryCategory] category
        fi
    done < $MANDATORY_CATEGORIES_FILE

    if [[ $taggedFileNameIsInvalid = true ]]; then

        ((invalidTaggedFileNameCount++))
    fi
done < $TAGGED_BASE_NAMES_FILE

echo $invalidTaggedFileNameCount non-representing mandatory categories files names
