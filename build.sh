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
    DISK_SIZE=3072
fi

if [ -z "$HEADLESS" ]; then
    HEADLESS=1
fi

if [ -z "$MAXPROCS" ]; then
    MAXPROCS=`nproc`
fi

TEMPLATE_DIR_DISPLAY="templates/$TEMPLATE_NAME"
RETURN_CODE=0

cd ${TEMPLATES_DIR}/${TEMPLATE_NAME}

../../scripts/gen-metadata.sh ../../httpdir/meta.data

packer build -var "disk_size=$DISK_SIZE" -var "ncpu=$MAXPROCS" -var "template_name=$TEMPLATE_NAME" -var "headless=$HEADLESS" template.json

qemu-img convert -q -c -f qcow2 -O qcow2 packer_output/${TEMPLATE_NAME} ${TEMPLATE_NAME}.qcow2

rm -r packer_output

for SIZE in 20G 50G 100G; do
    qemu-img create -q -f qcow2 ${TEMPLATE_NAME}-${SIZE}.qcow2 ${SIZE}

    #virt-resize --expand /dev/sda2 ${TEMPLATE_NAME}.qcow2 ${TEMPLATE_NAME}-${SIZE}.qcow2
done

#rm ${TEMPLATE_NAME}.qcow2
