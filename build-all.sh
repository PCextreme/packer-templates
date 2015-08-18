#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEMPLATES_DIR="${SCRIPT_DIR}/templates"

PACKER=$(which packer)
if [ -z "$PACKER" ]; then
    echo "Error: Packer could not be found in PATH"
    exit 1
fi

for TEMPLATE in $(find $TEMPLATES_DIR -maxdepth 1 -mindepth 1 -type d); do
    cd $TEMPLATE
    if [ ! -f "template.json" ]; then
        echo "Warning: Could not find template.json in $TEMPLATE Skipping."
        continue
    fi

    sh build.sh
    if [ "$?" -ne 0 ]; then
        echo "Error: Failed to build $TEMPLATE"
        continue
    fi
done
