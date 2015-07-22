#!/bin/bash

OUTPUT=$1

if [ -z "$OUTPUT" ]; then
    echo "Usage: $0 <output file>"
    exit 1
fi

GIT_REVISION=$(git rev-parse HEAD)
DATE=$(date -R)
PACKER_VERSION=$(packer --version)

echo "# PCextreme Aurora Packer Template" > $OUTPUT
echo "git revision: $GIT_REVISION" >> $OUTPUT
echo "build date: $DATE" >> $OUTPUT
echo "packer version: $PACKER_VERSION" >> $OUTPUT
