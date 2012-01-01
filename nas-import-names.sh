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
echo Following files have multiple whitespaces that must be trimmed
echo to avoid breaking other validation algorothms:
grep -E " {2,}" $FILES_NAMES