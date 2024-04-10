#!/bin/bash

NAS_TARGETTED_DIR=$(cat nas-dir.txt)

scp -Or rules/ $(cat ssh-host.txt):"$NAS_TARGETTED_DIR"