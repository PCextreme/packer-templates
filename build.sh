#!/bin/bash

TEMPLATE_NAME=$1

if [ $# -eq 0 ]; then
    echo "Usage: $0 <template>"
    exit 1
fi

set -ex

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPLATES_DIR="${SCRIPT_DIR}/templates"

# It could be that variables have already been set by Gitlab's CI for example
# Check if not defined before setting them
if [ -z "$DISK_SIZE" ]; then
    DISK_SIZE=4096
fi

if [ -z "$HEADLESS" ]; then
    HEADLESS=1
fi

if [ -z "$MAXPROCS" ]; then
    MAXPROCS=`nproc`
fi

echo "Building $TEMPLATE_NAME with disk size: $DISK_SIZE"

TEMPLATE_DIR_DISPLAY="templates/$TEMPLATE_NAME"
RETURN_CODE=0

cd ${TEMPLATES_DIR}/${TEMPLATE_NAME}

../../scripts/gen-metadata.sh ../../httpdir/meta.data

packer build -var "disk_size=$DISK_SIZE" -var "ncpu=$MAXPROCS" -var "template_name=$TEMPLATE_NAME" -var "headless=$HEADLESS" template.json
