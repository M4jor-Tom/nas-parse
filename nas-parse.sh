#!/bin/bash

bash nas-import-names.sh
bash split-tagged-and-not-names.sh
bash list-tags.sh
bash validate-tags-with-categories.sh
bash validate-tags-with-inheritance.sh
bash validate-categories-representation.sh

echo