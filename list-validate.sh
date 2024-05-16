#!/bin/bash

GENERATION_DIR=generated

mkdir -p $GENERATION_DIR

./validate-categories-inheritance.sh

if [[ $? -eq 1 ]]; then

    echo Ruleset not consistent. Aborting further processes
    echo
    exit
fi

./fetch-names.sh
./split-tagged-and-not-names.sh
./list-tags.sh
./validate-tags-with-categories.sh

if [[ $? -eq 1 ]]; then

    echo Unclassifiable tags found. Aborting further checks
    echo
    exit
fi

./validate-tags-with-inheritance.sh

if [[ $? -eq 1 ]]; then

    echo Some mother tags are forgotten along their child tags. Aborting further checks
    echo
    exit
fi

./validate-categories-representation.sh

echo
