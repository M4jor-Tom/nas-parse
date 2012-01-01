#/bin/bash

# VALIDATE THAT TAGS INHERITANCE ARE SET CORRECTLY
# BY CHECKING RULESETS DEFINED FOR THEIR CATEGORIES

CATEGORIES_INHERITANCE_DIR=categories-inheritance
TAGS_CATEGORIES_DIR=tags-categories
TAGS_INHERITANCE_DIR=tags-inheritance

echo
echo " --- [VALIDATION FOR CATEGORIES INHERITANCE] --- "

# For each category which implies to have others (children)
for motherCategoryPath in $CATEGORIES_INHERITANCE_DIR/*; do

    motherCategory=$(basename $motherCategoryPath | rev | cut -d "." -f 2 | rev)

    # For childCategory of the motherCategory (inside motherCategoryPath)
    while IFS= read -r childCategory; do

        echo "[RULE] Tags of category $motherCategory must inherit from a tag of category $childCategory"

        # For each father tag
        for fatherTagPath in $TAGS_INHERITANCE_DIR/*; do

            fatherTag=$(basename $fatherTagPath | rev | cut -d "." -f 2 | rev)

            # Neat thing here:
            # a FATHER tag must be of the CHILD category, and
            # a CHILD tag must be of the MOTHER category

            # This is because files in $CATEGORIES_INHERITANCE_DIR and
            # files in $TAGS_INHERITANCE_DIR are defined with inverted logic.

            # In $CATEGORIES_INHERITANCE_DIR: category.txt must have line and line categories
            # In $TAGS_INHERITANCE_DIR: fatherTag.txt defines line and line childrenTags

            # A tag must own 1 and 1 category only
            fatherTagCategoryPath=$(grep -Elr "^$fatherTag$" $TAGS_CATEGORIES_DIR)

            fatherTagCategory=$(basename $fatherTagCategoryPath | rev | cut -d "." -f 2 | rev)

            # $fatherTag is a $fatherTagCategory

            while IFS= read -r childTag; do

                childTagCategoryPath=$(grep -Elr "^$childTag$" $TAGS_CATEGORIES_DIR)

                childTagCategory=$(basename $childTagCategoryPath | rev | cut -d "." -f 2 | rev)

                echo $childTag is a $childTagCategory of $fatherTagCategory $fatherTag

            done < $fatherTagPath
        done
    done < $motherCategoryPath
done