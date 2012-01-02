#!/bin/bash

GENERATED_DIR=generated
FILES_NAMES=$GENERATED_DIR/files-names.txt
NAS_TARGETTED_DIR=$(cat nas-dir.txt)

mkdir -p $GENERATED_DIR

rm -rf $FILES_NAMES

ssh Tom@192.168.1.126 "find $NAS_TARGETTED_DIR" > $FILES_NAMES
