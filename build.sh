#!/bin/bash

# First argument must be the name for the template to build or all.
# eg. build.sh ubuntu1404 -r
# eg. build.sh --all
#
# Running build.sh without any arguments will show the help

EXIT_CODE=0

# Fucntions to display usage.
usage(){
    echo ""
    echo " Usage:"
    echo "        $0 [-a] [-c] [-d] [-h] [-r] [-t TEMPLATE ] [-u BUCKET]"
    echo ""
    echo " Parameters: (required)"
    echo "        -a                   Will build all the templates. [Cannot be used in combination with -t]"
    echo "        -t TEMPLATE          Will build the specified template. [Cannot be used in combination with -a]"
    echo ""
    echo " Options:"
    echo "        -c                   Will remove cached iso."
    echo "        -d                   Will show debug info."
    echo "        -h                   Will show this."
    echo "        -r                   Will remove qcow on finish."
    echo "        -u BUCKET            Will upload the template to the specified S3 bucket when build successfull."
    echo ""
    exit 1
}

# Show usage if no options are given.
if [ $# == 0 ]; then
    usage
fi

# Set all options to false.
REMOVE_CACHE=0
REMOVE_QCOW=0
UPLOAD_S3=0
S3_BUCKET=0
BUILD_TEMPLATE=0
BUILD_TEMPLATE_NAME=0
BUILD_ALL=0
DEBUG=0

# Loop over all arguments.
while getopts ":u:t:acdrh" OPT; do
    case $OPT in
    a)
        BUILD_ALL=1
        ;;
    c)
        REMOVE_CACHE=1
        ;;
    d)
        DEBUG=1
        ;;
    h)
        usage
        ;;
    r)
        REMOVE_QCOW=1
        ;;
    t)
        BUILD_TEMPLATE=1
        BUILD_TEMPLATE_NAME=$OPTARG
        ;;
    u)
        UPLOAD_S3=1
        S3_BUCKET=$OPTARG
        ;;
    \?)
        usage
        ;;
    esac
done

# If -a and -t are specied/not specified then show usage.
if [ $BUILD_ALL -eq $BUILD_TEMPLATE ]; then
    echo "Error: Must define only one of the following arguments -a or -t TEMPLATE."
    usage
fi

# DEBUG
if [ $DEBUG -eq 1 ]; then
    echo ""
    echo "DEBUG: REMOVE_CACHE: $REMOVE_CACHE"
    echo "DEBUG: REMOVE_QCOW: $REMOVE_QCOW"
    echo "DEBUG: UPLOAD_S3: $UPLOAD_S3"
    echo "DEBUG: S3_BUCKET: $S3_BUCKET"
    echo "DEBUG: BUILD_TEMPLATE: $BUILD_TEMPLATE"
    echo "DEBUG: BUILD_TEMPLATE_NAME: $BUILD_TEMPLATE_NAME"
    echo "DEBUG: BUILD_ALL: $BUILD_ALL"
    echo ""
fi

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
    START_MIN=$(date +%s)

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
        qemu-img convert -c -p -f qcow2 -O qcow2 packer_output/$TEMPLATE_NAME $TEMPLATE_NAME.qcow2

        if [ ! $? -eq 0 ]; then
            echo "Error: qemu-img failed to convert template."
            RETURN_CODE=1
        else
            if [ $UPLOAD_S3 -eq 1 ]; then
                echo "Info: Uploading template $TEMPLATE_NAME.qcow2 to S3 bucket s3://$S3_BUCKET."
                s3cmd put $TEMPLATE_NAME.qcow2 s3://$S3_BUCKET -P
            fi
        fi
    fi

    if [ -d "packer_output" ]; then
        echo "Info: Removing temporary folder packer_output"
        rm -fr packer_output
    fi

    if [ $REMOVE_CACHE -eq 1 ]; then
        if [ -d "packer_cache" ]; then
            echo "Info: Removing cached iso and folder packer_cache."
            rm -rf packer_cache
        fi
    fi

    if [ $REMOVE_QCOW -eq 1 ]; then
        echo "Info: Removing qcow $TEMPLATE_NAME.qcow2."
        rm -f $TEMPLATE_NAME.qcow2
    fi


    END_MIN=$(date +%s)
    DIFF_MIN=$(expr $(echo "$END_MIN - $START_MIN" | bc) / 60)
    echo "Info: Time to build template $TEMPLATE_NAME: $DIFF_MIN minutes."

    return $RETURN_CODE
}

# Logic to select template or build all.
if [ $BUILD_ALL -eq 1 ]; then
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

elif [ -f "$TEMPLATES_DIR/$BUILD_TEMPLATE_NAME/template.json" ]; then
    echo "Info: Building template $BUILD_TEMPLATE_NAME"
    build_template $BUILD_TEMPLATE_NAME

    if [ "$?" -ne 0 ]; then
        echo "Error: Failed to build $BUILD_TEMPLATE_NAME"
        EXIT_CODE=1
    fi

else
    echo "Error: Template $BUILD_TEMPLATE_NAME doesn't exist!"
    EXIT_CODE=1
fi

exit $EXIT_CODE
