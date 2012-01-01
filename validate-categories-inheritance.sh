#/bin/bash

# VALIDATE THAT TAGS INHERITANCE ARE SET CORRECTLY
# BY CHECKING RULESETS DEFINED FOR THEIR CATEGORIES

GENERATION_DIR=generated

CATEGORIES_INHERITANCE_DIR=rules/categories-inheritance
TAGS_CATEGORIES_DIR=rules/tags-categories
TAGS_INHERITANCE_DIR=rules/tags-inheritance

LAST_SUM_FILE=$GENERATION_DIR/last-sum.txt
LAST_VALID_SUM_FILE=$GENERATION_DIR/last-valid-sum.txt
LAST_INVALID_SUM_FILE=$GENERATION_DIR/last-invalid-sum.txt

LOGS_FILE=$GENERATION_DIR/$0.log

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

./identify-ruleset.sh $LAST_SUM_FILE
lastSum=$(cat $LAST_SUM_FILE)

echo
echo " --- [VALIDATION FOR CATEGORIES INHERITANCE] --- "

if [[ -f $LAST_VALID_SUM_FILE ]]; then

    lastValidSum=$(cat $LAST_VALID_SUM_FILE)

    if [[ $lastSum == $lastValidSum ]]; then

        echo The current ruleset is the same valid as before.
        echo Using cached sum: $lastValidSum
        echo
        echo
        exit 0
    fi
fi

if [[ -f $LAST_INVALID_SUM_FILE ]]; then

    lastInvalidSum=$(cat $LAST_INVALID_SUM_FILE)
    
    if [[ $lastSum == $lastInvalidSum ]]; then

        echo The current ruleset is the same invalid as before.
        echo Using cached sum: $lastInvalidSum
        echo
        cat $LOGS_FILE
        echo
        echo
        exit 1
    fi
fi

rm -f $LOGS_FILE

exitCode=0

# For each category which implies to have others (children)
for motherCategoryPath in $CATEGORIES_INHERITANCE_DIR/*; do

    motherCategory=$(basename $motherCategoryPath | rev | cut -d "." -f 2 | rev)

    # For daughterCategory of the motherCategory (inside motherCategoryPath)
    for daughterCategory in $(cat $motherCategoryPath); do

        echo [RULE] Tags of category [$motherCategory] must inherit from a tag of category [$daughterCategory]

        motherCategoryElementsCount=$(cat $TAGS_CATEGORIES_DIR/$motherCategory.txt | wc -l)
        motherCategoryElementsIndex=0
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

                if [[ $fatherTagCategoryPath == "" ]]; then

                    log="$fatherTag does not have a category"
                    echo $log
                    echo $log >> $LOGS_FILE
                    exit 1
                fi

                fatherTagCategory=$(basename $fatherTagCategoryPath | rev | cut -d "." -f 2 | rev)

                if [[ $fatherTagCategory == $daughterCategory ]]; then

                    if test -f $TAGS_INHERITANCE_DIR/$fatherTag.txt && grep -qlE "^$sonTag\$" "$TAGS_INHERITANCE_DIR/$fatherTag.txt"; then

                        sonTagsHasDaughterCategoryPath=true
                    fi
                fi
            done

            if [[ $sonTagsHasDaughterCategoryPath = false ]]; then

                log="{$sonTag} does not have a [$daughterCategory] but it's a [$motherCategory]"
                echo $log
                echo $log >> $LOGS_FILE
                exitCode=1
            fi

            ((motherCategoryElementsIndex++))

            echo $motherCategoryElementsIndex / $motherCategoryElementsCount
            echo -e "\033[2A"

            # echo $sonTag is a $motherCategory of $fatherTagCategory $fatherTag

        done < $TAGS_CATEGORIES_DIR/$motherCategory.txt
    done
done

echo

if [[ $exitCode -eq 0 ]]; then

    echo Ruleset valid, caching its sum...
    ./identify-ruleset.sh $LAST_VALID_SUM_FILE

elif [[ $exitCode -eq 1 ]]; then

    echo Ruleset not valid, caching its sum...
    ./identify-ruleset.sh $LAST_INVALID_SUM_FILE
fi

echo
echo

exit $exitCode
