#!/bin/bash
set -e

CURRENT_DIR=`dirname $0`
. ${CURRENT_DIR}/settings.ini

API_URL='https://www.data.gouv.fr/api/1'

FILE_NAME="itineraires_rando_export.json"

FILE_PATH="${CURRENT_DIR}/../generated_data/${FILE_NAME}"

# Publication sur data.gouv.fr

if [ -f "${FILE_PATH}" ]; then
  curl -H "Accept:application/json" \
      -H "X-Api-Key:$API_KEY" \
      -F "file=@${FILE_PATH}" \
      -X POST ${API_URL}/datasets/${DATASET}/resources/${RESOURCE}/upload/
  echo "Le push a été réalisé"
  exit 0
else
  echo "${FILE_PATH} does not exist."
  exit 1
fi
