#!/bin/bash

# VERIFY THAT EACH TAG IS IN A CATEGORY, SO IT'S KNOWN

GENERATION_DIR=generated
TAGS_DIR=$GENERATION_DIR/tags
CATEGORIES_DIR=rules/tags-categories

echo
echo " --- [TAGS CATEGORIES VALIDATION] --- "

exitCode=0
invalidTags=0
for tagFile in $TAGS_DIR/*; do

    tag=$(basename $tagFile | rev | cut -c 5- | rev)

    if ! grep -Eqr "^$tag$" $CATEGORIES_DIR; then

        exitCode=1

        # Tag in nas not found amongst
        # those in categories
        echo Can\'t classify tag {$tag}

        ((invalidTags++))
    fi
done

ghostTags=0
for categoryPath in $CATEGORIES_DIR/*; do

    while IFS= read -r tag; do

        if ! [[ -f $TAGS_DIR/$tag.txt ]]; then

            echo Ghost tag: {$tag}

            ((ghostTags++))
        fi
    done < $categoryPath
done

echo $invalidTags unkown tags found
echo $ghostTags ghost tags found

exit $exitCode
