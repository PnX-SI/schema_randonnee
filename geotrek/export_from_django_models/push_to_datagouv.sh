. settings.ini

API_URL='https://www.data.gouv.fr/api/1'
EXPORT_PATH="../.."
FILE_NAME="itineraires_rando_export.json"


# Publication sur etalab

if [[ -f "${EXPORT_PATH}/$FILE_NAME" ]]; then
  curl -H "Accept:application/json" \
      -H "X-Api-Key:$API_KEY" \
      -F "file=@${EXPORT_PATH}/${FILE_NAME}" \
      -X POST $API_URL/datasets/$DATASET/resources/$RESOURCE/upload/
else
  echo "${EXPORT_PATH}/${FILE_NAME} does not exist."
fi

