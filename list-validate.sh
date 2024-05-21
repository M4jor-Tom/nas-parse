#!/bin/bash

GENERATION_DIR=generated

mkdir -p $GENERATION_DIR

./validate-categories-inheritance.sh

if [[ $? -ne 0 ]]; then

    echo Ruleset not consistent. Aborting further processes
    echo
    exit 1
fi

./fetch-names.sh
./split-tagged-and-not-names.sh
./list-tags.sh
./validate-tags-with-categories.sh

if [[ $? -ne 0 ]]; then

    echo Unclassifiable tags found. Aborting further checks
    echo
    exit 2
fi

./validate-tags-with-inheritance.sh

if [[ $? -ne 0 ]]; then

    echo Some mother tags are forgotten along their child tags. Aborting further checks
    echo
    exit 3
fi

./validate-categories-representation.sh

echo
