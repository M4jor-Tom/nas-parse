#/bin/bash

# VALIDATE THAT TAGS INHERITANCE ARE SET CORRECTLY
# BY CHECKING RULESETS DEFINED FOR THEIR CATEGORIES

CATEGORIES_INHERITANCE_DIR=categories-inheritance
TAGS_CATEGORIES_DIR=tags-categories
TAGS_INHERITANCE_DIR=tags-inheritance

# Neat thing here:
# a FATHER tag must be of the CHILD category, and
# a CHILD tag must be of the MOTHER category

# This is because files in $CATEGORIES_INHERITANCE_DIR and
# files in $TAGS_INHERITANCE_DIR are defined with inverted logic.

# In $CATEGORIES_INHERITANCE_DIR: category.txt must have line and line categories
# In $TAGS_INHERITANCE_DIR: fatherTag.txt defines line and line childrenTags

# Example:
# -> motherCategory: person (file in $TAGS_CATEGORIES_DIR/ for sure)
# -> daughterCategory: age (file in $TAGS_CATEGORIES_DIR/ for sure)
# -> fatherTag: adult (inside file $TAGS_CATEGORIES_DIR/*.txt for sure)
# -> sonTag: someone_cool (inside file $TAGS_CATEGORIES_DIR for sure)
# There is an error to detect here if $TAGS_INHERITANCE_DIR/adult.txt does not contain "someone_cool"
# There is an error to detect here if $TAGS_INHERITANCE_DIR/$fatherTag.txt does not contain "$sonTag"
# -> person_with_no_age has no category of type age

echo
echo " --- [VALIDATION FOR CATEGORIES INHERITANCE] --- "

# For each category which implies to have others (children)
for motherCategoryPath in $CATEGORIES_INHERITANCE_DIR/*; do

    motherCategory=$(basename $motherCategoryPath | rev | cut -d "." -f 2 | rev)

    # For daughterCategory of the motherCategory (inside motherCategoryPath)
    while IFS= read -r daughterCategory; do

        echo [RULE] Tags of category [$motherCategory] must inherit from a tag of category [$daughterCategory]

        while IFS= read -r sonTag; do

            # echo {$sonTag} must have a [$daughterCategory] because it\'s a [$motherCategory]

            sonTagsHasDaughterCategoryPath=false

            # $sonTag\'s category is $motherCategory.
            # The point of this script is to check that
            # it has a tag of category $daughterCategory.

            # For each father tag
            for fatherTagPath in $TAGS_INHERITANCE_DIR/*; do

                fatherTag=$(basename $fatherTagPath | rev | cut -d "." -f 2 | rev)

                fatherTagCategoryPath=$(grep -Elr "^$fatherTag$" $TAGS_CATEGORIES_DIR)
                fatherTagCategory=$(basename $fatherTagCategoryPath | rev | cut -d "." -f 2 | rev)

                if [[ $fatherTagCategory == $daughterCategory ]]; then

                    if grep -qlE "^$sonTag\$" "$TAGS_INHERITANCE_DIR/$fatherTag.txt"; then

                        sonTagsHasDaughterCategoryPath=true
                    fi
                fi
            done

            if [[ $sonTagsHasDaughterCategoryPath = false ]]; then

                echo {$sonTag} does not have a [$daughterCategory] but it\'s a [$motherCategory]
            fi

            # echo $sonTag is a $motherCategory of $fatherTagCategory $fatherTag

        done < $TAGS_CATEGORIES_DIR/$motherCategory.txt
    done < $motherCategoryPath
done