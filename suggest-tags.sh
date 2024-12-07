#!/bin/bash

GENERATION_DIR=generated
INVALID_BASE_NAMES_PATH=$GENERATION_DIR/invalid-base-names.txt
NON_MANDATORY_TAGS_REPRESENTING_TAGLESS_FILES_NAMES_PATH=$GENERATION_DIR/non-mandatory-tags-representing-tagless-files-names.txt
TAGS_DIR=$GENERATION_DIR/tags

echo
echo " --- [TAGS SUGGESTING] --- "

for tagPath in $TAGS_DIR/*; do

    tag=$(basename $tagPath | cut -d '.' -f 1)
    FILES_NAMES=$(grep -i "$tag" $NON_MANDATORY_TAGS_REPRESENTING_TAGLESS_FILES_NAMES_PATH)

    if [[ $FILES_NAMES != "" ]]; then

        echo "- Tag $tag may be suitable for:"

        for taglessFileName in "${FILES_NAMES[@]}"; do

            if ! grep -q "$taglessFileName" $tagPath; then

                echo "$taglessFileName"
            fi
        done
    fi
done
