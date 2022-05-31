#!/bin/bash

CURRENT_DIR=`dirname $0`
. ${CURRENT_DIR}/settings.ini

API_URL='https://www.data.gouv.fr/api/1'

FILE_NAME="itineraires_rando_export.json"

if [ -z ${EXPORT_FILE_NAME+x} ];
then
  EXPORT_FILE_NAME="itineraires_rando_export"
fi
FULL_FILE_PATH=${CURRENT_DIR}/../${EXPORT_FILE_NAME}.json

mv ${CURRENT_DIR}/../${FILE_NAME} ${FULL_FILE_PATH}

# Publication sur data.gouv.fr

if [ -f "${FULL_FILE_PATH}" ]; then
  curl -H "Accept:application/json" \
      -H "X-Api-Key:$API_KEY" \
      -F "file=@${FULL_FILE_PATH}" \
      -X POST $API_URL/datasets/$DATASET/resources/$RESOURCE/upload/
else
  echo "${FULL_FILE_PATH} does not exist."
fi
