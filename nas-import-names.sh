#!/bin/bash

# GETTING FILES NAMES FROM NAS

GENERATED_DIR=generated
FILES_NAMES=$GENERATED_DIR/files-names.txt
NAS_TARGETTED_DIR=$(cat nas-dir.txt)

mkdir -p $GENERATED_DIR

rm -rf $FILES_NAMES

ssh $(cat ssh-host.txt) "find $NAS_TARGETTED_DIR/*/*.mp4" > $FILES_NAMES

filesCount=$(wc -l < $FILES_NAMES)

echo
echo " --- [FILES NAMES IMPORTING] --- "
echo $filesCount files names imported
echo Files with multiple whitespaces:
grep -E " {2,}" $FILES_NAMES

echo Files with square brackets:
grep -E "\[" $FILES_NAMES
grep -E "\]" $FILES_NAMES