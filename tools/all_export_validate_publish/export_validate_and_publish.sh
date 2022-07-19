#!/bin/bash

set -e

CURRENT_DIR=$(dirname "$(realpath $0)")
GENERATED_DATA_DIR="${CURRENT_DIR}/../generated_data"

. ${CURRENT_DIR}/settings.ini

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

if [ "$CLEAN_LOG" = true ]; then
  > ${GENERATED_DATA_DIR}/validation.log
fi

date >> ${GENERATED_DATA_DIR}/validation.log

# Run scripts if activated in settings.ini
if [ "$EXPORT_GEOTREK_APP" = true ] ; then
  echo "Export data..."
  func ${CURRENT_DIR}/../1_export_geotrek_app/export.sh  >> ${GENERATED_DATA_DIR}/validation.log
fi

if [ "$VALIDATE" = true ] ; then
  echo "Validate data..."
  func ${CURRENT_DIR}/../2_validate_data/validate.sh  >> ${GENERATED_DATA_DIR}/validation.log
fi


if [ "$PUBLISH_DATA_GOUV" = true ] ; then
  echo "Publish data..."
  func ${CURRENT_DIR}/../3_publish_data_gouv_fr/push_to_datagouv.sh  >> ${GENERATED_DATA_DIR}/validation.log
fi

echo "" >> ${GENERATED_DATA_DIR}/validation.log
