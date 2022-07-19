#!/bin/bash

set -e

CURRENT_DIR=$(dirname "$(realpath $0)")

. ./settings.ini

stop () {
    echo "${1}" 1>&2
    exit 1
}

func () {
    if $1; then
        echo "  ... done"
    else
        stop "  ... something went wrong"
    fi
}

# Run scripts if activated
if [ "$EXPORT_GEOTREK_APP" = true ] ; then
  echo "Export data"
  func $CURRENT_DIR/../1_export_geotrek_app/export.sh
fi

if [ "$VALIDATE" = true ] ; then
  echo "Validate data"
  func $CURRENT_DIR/../2_validate_data/validate.sh
fi


if [ "$PUBLISH_DATA_GOUV" = true ] ; then
  echo "Publish data"
  func $CURRENT_DIR/../3_publish_data_gouv_fr/push_to_datagouv.sh
fi