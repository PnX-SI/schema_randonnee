#!/bin/bash

CURRENT_DIR=$(dirname "$(realpath $0)")
GENERATED_DATA_DIR="${CURRENT_DIR}/../generated_data"

# Validation des données exportées
# Lancement du validateur
cd ${CURRENT_DIR}
source venv/bin/activate
date >> ${GENERATED_DATA_DIR}/validation.log
python3 validate_data_with_jsonschema.py >> ${GENERATED_DATA_DIR}/validation.log
valid=$?
echo "" >> ${GENERATED_DATA_DIR}/validation.log

if [ "$valid" = 0 ]; then
    mv ${GENERATED_DATA_DIR}/itineraires_rando.json ${GENERATED_DATA_DIR}/itineraires_rando_export.json
    echo "Fichier valide et exporté vers schema_randonnee/tools/generated_data/itineraires_rando_export.json"
else
    mv ${GENERATED_DATA_DIR}/itineraires_rando.json ${GENERATED_DATA_DIR}/itineraires_rando_notvalid.json
    echo "Fichier non valide et exporté vers schema_randonnee/tools/generated_data/itineraires_rando_not_valid.json"
    echo "Voir tools/generated_data/validation.log pour plus de détails"
fi

echo ""
