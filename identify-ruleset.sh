#!/bin/bash

if [[ "$#" -ne 1 ]]; then

    echo "Usage: $0 <sum-file>"
    exit
fi

GENERATION_DIR=generated

SUM_FILE=$1

RULES_DIR=rules
RULES_ARCHIVE=$GENERATION_DIR/$RULES_DIR.tar.gz
SUM_ALGORITHM=sha256sum

rm -f $SUM_FILE
rm -f $RULES_ARCHIVE

echo
echo " --- [RULES IDENTIFICATION] --- "
echo Zipping ruleset...

tar -czf $RULES_ARCHIVE $RULES_DIR

echo $RULES_ARCHIVE created
echo Calculating sum...

sum=$($SUM_ALGORITHM $RULES_ARCHIVE | cut -d " " -f 1)

echo $sum >> $SUM_FILE

echo $SUM_FILE created with sum $sum
