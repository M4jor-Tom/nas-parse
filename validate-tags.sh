#!/bin/bash

GENERATION_DIR=generated
TAGS_DIR=$GENERATION_DIR/tags
CATEGORIES_DIR=tags-categories

invalidTags=0
for tagFile in $TAGS_DIR/*; do

    tag=$(basename $tagFile | rev | cut -c 5- | rev)

    if ! grep -qr $tag $CATEGORIES_DIR; then

        # Tag not found
        echo Can\'t classify tag {$tag}

        ((invalidTags++))
    fi
done

echo $invalidTags invalid tags found
