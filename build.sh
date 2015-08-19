#!/bin/bash

# First argument must be the name for the template to build or all.
# eg. build.sh ubuntu1404 -r
# eg. build.sh --all
#
# Running build.sh without any arguments will show the help

EXIT_CODE=0

if [ $# == 0 ]; then
    echo ""
    echo " Usage:"
    echo "        $0 template_name [-r]  Will build the specified template."
    echo "        $0 --all         [-r]  Will build all templates."
    echo ""
    echo " Options:"
    echo "        -r    Will remove cached iso."
    echo ""
    exit 1
fi

# Set all options to false.
REMOVE_CACHE=0

# Loop over all arguments.
if [ $# -gt 1 ]; then
    for ARGUMENT in "$@"
    do
        case $ARGUMENT in
        "-r")
            REMOVE_CACHE=1
            ;;
        esac
    done

fi

TEMPLATE_ARGUMENT=$1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPLATES_DIR="${SCRIPT_DIR}/templates"

PACKER=$(which packer)
if [ -z "$PACKER" ]; then
    echo "Error: Packer could not be found in PATH!"
    exit 1
fi

QEMU_IMG=$(which qemu-img)
if [ -z "$QEMU_IMG" ]; then
    echo "Error: qemu-img could not be found in PATH!"
    exit 1
fi

# Export environment variable GOMAXPROCS
export GOMAXPROCS=`nproc`

# Fucntions to build template
build_template(){
    # First argument passed to build_template is the name.
    local TEMPLATE_NAME=$1
    local TEMPLATE_DIR_DISPLAY="templates/$TEMPLATE_NAME"
    local RETURN_CODE=0

    echo "Info: Entering directory $TEMPLATE_DIR_DISPLAY"
    cd "$TEMPLATES_DIR/$TEMPLATE_NAME"

    if [ -d "packer_output" ]; then
        echo "Info: Folder packer_output exists. Removing folder."
        rm -fr packer_output
    fi

    echo "Info: Generating meta.data file."
    ../../scripts/gen-metadata.sh ../../httpdir/meta.data

    echo "Info: Starting Packer.IO build of $TEMPLATE_DIR_DISPLAY/template.json."
    packer build \
        -var "ncpu=$GOMAXPROCS" \
        -var "template_name=$TEMPLATE_NAME" \
        template.json

    if [ ! $? -eq 0 ]; then
        echo "Error: Packer.IO build unsuccesfull, stopping."
        RETURN_CODE=1
    else
        echo "Info: Converting template packer_output/$TEMPLATE_NAME to $TEMPLATE_NAME.qcow2."
        qemu-img convert -c -f qcow2 -O qcow2 packer_output/$TEMPLATE_NAME $TEMPLATE_NAME.qcow2

        if [ ! $? -eq 0 ]; then
            echo "Error: qemu-img failed to convert template."
            RETURN_CODE=1
        fi
    fi

    if [ -d "packer_output" ]; then
        echo "Info: Removing temporary folder packer_output"
        rm -fr packer_output
    fi

    if [ $REMOVE_CACHE == 1 ]; then
        if [ -d "packer_cache" ]; then
            echo "Info: Removing cached iso and folder packer_cache."
            rm -rf packer_cache
        fi
    fi

    return $RETURN_CODE
}

# Logic to select template or build all.
if [ $TEMPLATE_ARGUMENT == '--all' ]; then
    echo "Info: Building all!"
    cd $TEMPLATES_DIR

    for TEMPLATE in $(find $TEMPLATES_DIR -maxdepth 1 -mindepth 1 -type d -printf "%f\n"); do
        cd $TEMPLATE
        if [ -f "template.json" ]; then
            build_template $TEMPLATE

            if [ "$?" -ne 0 ]; then
                echo "Error: Failed to build $TEMPLATE"
                EXIT_CODE=1
            fi
        fi
        cd $TEMPLATES_DIR
    done

elif [ -f "$TEMPLATES_DIR/$TEMPLATE_ARGUMENT/template.json" ]; then
    echo "Info: Building template $TEMPLATE_ARGUMENT"
    build_template $TEMPLATE_ARGUMENT

    if [ "$?" -ne 0 ]; then
        echo "Error: Failed to build $TEMPLATE"
        EXIT_CODE=1
    fi

else
    echo "Error: Template $TEMPLATE_ARGUMENT doesn't exist!"
    EXIT_CODE=1
fi

exit $EXIT_CODE