
CURRENT_DIR=`dirname $0`
. ${CURRENT_DIR}/settings.ini

API_URL='https://www.data.gouv.fr/api/1'

FILE_NAME="itineraires_rando_export.json"


# Publication sur etalab

if [[ -f "${CURRENT_DIR}/../$FILE_NAME" ]]; then
  curl -H "Accept:application/json" \
      -H "X-Api-Key:$API_KEY" \
      -F "file=@${CURRENT_DIR}/../${FILE_NAME}" \
      -X POST $API_URL/datasets/$DATASET/resources/$RESOURCE/upload/
else
  echo "${CURRENT_DIR}/../${FILE_NAME} does not exist."
fi

