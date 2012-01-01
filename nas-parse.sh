#!/bin/bash

bash validate-categories-inheritance.sh

if [[ $? -eq 1 ]]; then

    echo Validation of tags rulesets failed. Aborting further checks
    echo
    exit
fi

bash nas-import-names.sh
bash split-tagged-and-not-names.sh
bash list-tags.sh
bash validate-tags-with-categories.sh
bash validate-tags-with-inheritance.sh
bash validate-categories-representation.sh

echo
