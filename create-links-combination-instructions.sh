#!/bin/bash

GENERATION_DIR=generated

# Input filters dir
FILTERS_DIR=filters

# Input tags link dir
TAGS_LINK_DIR=$GENERATION_DIR/tags-link

# For each filter path specifying a filter to create
for filterPath in $FILTERS_DIR/*; do

    # Extract the name of the filter
    filterName=$(basename $filterPath | cut -d "." -f 1)

    # Extract the and/or operator
    filterOperator=$(basename $filterPath | cut -d "." -f 2)

    # Determine the operations to do accordingly to the filter type
    if [[ $filterOperator == "or" ]]; then

        filesToLink=()

        while IFS= read -r tag; do

            echo $tag OR

        done < $filterPath

    elif [[ $filterOperator == "and" ]]; then

        filesToLink=()
        
        while IFS= read -r tag; do

            echo $tag AND

        done < $filterPath

    else

        echo Invalid filter operator "$filterOperator" for $filterPath. It must be 'or' or 'and'.
        exit 1
    fi
done
