#!/bin/bash

GENERATED_DIR=generated
NAMES_FILE=$GENERATED_DIR/files-names.txt

VALID_AWK_SRC="/\{(\w+)\}+ .*/"
VALID_BASE_NAMES_FILE=$GENERATED_DIR/valid-base-names.txt

INVALID_AWK_SRC="!$VALID_AWK_SRC"
INVALID_BASE_NAMES_FILE=$GENERATED_DIR/invalid-base-names.txt

# Clean generted files names lists
rm -f $VALID_BASE_NAMES_FILE $INVALID_BASE_NAMES_FILE

# Find valid files names
awk -F "/" "$VALID_AWK_SRC {print \$NF}" $NAMES_FILE > $VALID_BASE_NAMES_FILE

# Find invalid files names
awk -F "/" "$INVALID_AWK_SRC {print \$NF}" $NAMES_FILE > $INVALID_BASE_NAMES_FILE
