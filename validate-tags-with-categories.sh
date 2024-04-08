#!/bin/bash

GENERATION_DIR=generated
TAGS_DIR=$GENERATION_DIR/tags
CATEGORIES_DIR=tags-categories

echo
echo " --- [TAGS VALIDATION] --- "

invalidTags=0
for tagFile in $TAGS_DIR/*; do

    tag=$(basename $tagFile | rev | cut -c 5- | rev)

    if ! grep -Eqr "^$tag$" $CATEGORIES_DIR; then

        # Tag in nas not found amongst
        # those in categories
        echo Can\'t classify tag {$tag}

        ((invalidTags++))
    fi
done

echo $invalidTags invalid tags found
