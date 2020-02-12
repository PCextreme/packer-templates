#!/bin/bash
set -ex

TEMPLATE_NAME=$1

if [ $# -eq 0 ]; then
    echo "Usage: $0 <template>"
    exit 1
fi

packer build -var-file=templates/${TEMPLATE_NAME}.json \
	-var "name=${TEMPLATE_NAME}" \
	templates/base.json
