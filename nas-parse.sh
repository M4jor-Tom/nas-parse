#!/bin/bash

GENERATION_DIR=generated

mkdir -p $GENERATION_DIR

./validate-categories-inheritance.sh

if [[ $? -eq 1 ]]; then

    echo Validation of tags rulesets failed. Aborting further checks
    echo
    exit
fi

./nas-import-names.sh
./split-tagged-and-not-names.sh
./list-tags.sh
./validate-tags-with-categories.sh
./validate-tags-with-inheritance.sh
./validate-categories-representation.sh

echo
