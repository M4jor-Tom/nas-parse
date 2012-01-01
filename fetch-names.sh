#!/bin/bash

# GETTING FILES NAMES FROM NAS

GENERATION_DIR=generated
FILES_NAMES=$GENERATION_DIR/files-names.txt
NAS_TARGETTED_DIR=$(cat nas-dir.txt)

rm -rf $FILES_NAMES

ssh $(cat ssh-host.txt) "find $NAS_TARGETTED_DIR/*/*.mp4" > $FILES_NAMES
ssh $(cat ssh-host.txt) "find $NAS_TARGETTED_DIR/*/*.webm" >> $FILES_NAMES

filesCount=$(wc -l < $FILES_NAMES)

echo
echo " --- [FILES NAMES IMPORTING] --- "
echo $filesCount files names imported
echo Files with multiple whitespaces:
grep -E " {2,}" $FILES_NAMES

echo Files with square brackets:
grep -E "\[" $FILES_NAMES
grep -E "\]" $FILES_NAMES

echo Files not ending with .mp4 or .webm:
grep -Ev ".*\.(mp4|webm)" $FILES_NAMES | grep -v "@eaDir" | grep -v "desktop.ini"
