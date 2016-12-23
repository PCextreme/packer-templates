
#!/bin/bash
set -e
#
# Configuration files are located in the template directories.
#
# Usage example:
# ./cloudmonkey.sh -t centos72 -u http://o.auroraobjects.eu/{bucket}

# Functions to display usage.
usage(){
    echo
    echo " Usage:"
    echo "        $0 [-a] [-t TEMPLATE_NAME ] [-u URL ] [-s SIZE] [-r] [-d] [-h]"
    echo
    echo " Parameters: (required)"
    echo "        -a                 Uploads all templates."
    echo "        -t TEMPLATE        Uploads a single template. Cannot be combined with -a."
    echo "        -u URL             HTTP folder URL where templates can be downloaded from."
    echo "        -s SIZE            Size of the template that will be added"
    echo
    echo " Options:"
    echo "        -r                 Unfeatures the older version of the template, if found."
    echo "        -d                 Will show debug info."
    echo "        -p PROFILE         Cloudmonkey profile."
    echo "        -h                 Will show this."
    echo
    echo " Usage example:"
    echo "         ${0} -t centos73 -u http://o.auroraobjects.eu/{bucket} -s 20GB"
    echo
    exit 1
}

# Show usage if no options are given.
if [ $# == 0 ]; then
    usage
fi

# Set all options to false.
UPLOAD_ALL=0
SINGLE=0
TEMPLATE=0
UNFEATURE=0
DEBUG=0

# Loop over all arguments.
while getopts ":p:t:u:s:ardh" OPT; do
    case $OPT in
    a) UPLOAD_ALL=1
       ;;
    t) SINGLE=1
       TEMPLATE=$OPTARG
       ;;
    u) DOWNLOAD_URL=$OPTARG
       ;;
    r) UNFEATURE=1
       ;;
    s) SIZE=$OPTARG
       ;;
    d) DEBUG=1
       ;;
    h) usage
       ;;
    p) CMPROFILE="-p ${OPTARG}"
       ;;
    \?) usage
       ;;
    esac
done

# If -a and -t are specied/not specified then show usage.
if [ $SINGLE -eq $UPLOAD_ALL ]; then
    echo "Error: Must define only one of the following arguments -a or -t TEMPLATE."
    usage
fi

# DEBUG
if [ $DEBUG -eq 1 ]; then
    echo ""
    echo "DEBUG: UPLOAD_ALL: $UPLOAD_ALL"
    echo "DEBUG: SINGLE: $SINGLE"
    echo "DEBUG: TEMPLATE: $TEMPLATE"
    echo "DEBUG: DOWNLOAD_URL: $DOWNLOAD_URL"
    echo "DEBUG: SIZE: $SIZE"
    echo "DEBUG: UNFEATURE: $UNFEATURE"
    echo "DEBUG: DEBUG: $DEBUG"
    echo ""
fi

if [ -z $DOWNLOAD_URL ]; then
    echo "Error: Must define a valid URL"
    usage
fi

if [ -z $SIZE ]; then
    echo "Error: You must specify the size of the template that will be added"
    usage
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPLATES_DIR="${SCRIPT_DIR}/templates"

exitwitherror() {
  echo -e "\n$1\n"
  exit 1
}

# Function to upload template
upload_template(){

    # First argument passed to upload_template is the template name.
    local TEMPLATE_NAME=$1
    local TEMPLATE_CONFIG="$TEMPLATES_DIR/$TEMPLATE_NAME/cloudmonkey.conf"

    # Include config file
    [[ ! -f "${TEMPLATE_CONFIG}" ]] && {
      exitwitherror "Config file does not exist"
    }
    . $TEMPLATE_CONFIG
    # We have to specify a ostypeid for each template. To fix this we need to due a very basic lookup
    # based on the name described in $osdescription
    #
    # Not the best solution, but it works for now.
    #
    echo "Info: Looking up ostypeid -> ${osdescription}"
    ostypeid=$(cloudmonkey ${CMPROFILE} -d default list ostypes filter=id description="${osdescription}" | awk '/id = / {print $3}'|head -n 1)

    if [ -z "${ostypeid}" ]; then
        echo "Error: Could not find ostypeid for ${osdescription}"
        exit 1
    fi

    echo "Info: Found ostypeid ${ostypeid}"

    echo "Info: Adding $TEMPLATE_NAME"
    added=$(cloudmonkey ${CMPROFILE} -d default register template name="${name}" displaytext="${SIZE}" isextractable=${extractable} isfeatured=${featured} ispublic=${public} passwordenabled=${passwordenabled} ostypeid=${ostypeid} format=${format} hypervisor=${hypervisor} zoneid=${zoneid} url="${DOWNLOAD_URL}/${TEMPLATE_NAME}.qcow2" | awk '/^id =/ {print $3}')

    echo "Info: Adding tags to $TEMPLATE_NAME"
    tags=$(cloudmonkey ${CMPROFILE} -d default create tags resourcetype=template resourceids=$added tags[0].key=oscategory tags[0].value=$oscategory tags[1].key=osversion tags[1].value=$osversion tags[2].key=size tags[2].value=$SIZE | awk '/^id =/ {print $3}')

    if [ $UNFEATURE -eq 1 ]; then
      echo "Info: Searching for old template  -> $name"
      old=$(cloudmonkey ${CMPROFILE} -d default list templates name="$name" templatefilter=featured tags[0].key=size tags[0].value=$SIZE | awk '/^id =/ {print $3}')

      if [ -z "${old}" ]; then
          echo "Warning: Could not find old template"
      else
          echo "Info: Found $old setting featured to false"
          unf=$(cloudmonkey ${CMPROFILE} -d default update templatepermissions id=$old isfeatured=false)
      fi
    fi
    echo "Info: Finished $TEMPLATE_NAME"
}

# Logic to upload a single template or upload all.
if [ $UPLOAD_ALL -eq 1 ]; then
    echo "Info: Processing all templates!"
    cd $TEMPLATES_DIR
    for TEMPLATE in $(find $TEMPLATES_DIR -maxdepth 1 -mindepth 1 -type d -printf '%f\n'); do
        cd $TEMPLATE
        if [ -f "cloudmonkey.conf" ]; then
            upload_template $TEMPLATE

            if [ "$?" -ne 0 ]; then
                echo "Error: Failed to upload $TEMPLATE"
            fi
        fi
        cd $TEMPLATES_DIR
    done

elif [ -f "$TEMPLATES_DIR/$TEMPLATE/cloudmonkey.conf" ]; then
    echo "Info: Processing template $TEMPLATE"
    upload_template $TEMPLATE

    if [ "$?" -ne 0 ]; then
        echo "Error: Failed to upload $TEMPLATE"
    fi

else
    echo "Error: Template $TEMPLATE doesn't exist!"
fi
