#!/bin/bash

RULES_DIR=rules
RULES_TAR=$RULES_DIR.tar.gz

tar -czf $RULES_TAR $RULES_DIR

NAS_TARGETTED_DIR=$(cat nas-dir.txt)

scp -Or $RULES_TAR $(cat ssh-host.txt):"$NAS_TARGETTED_DIR"
