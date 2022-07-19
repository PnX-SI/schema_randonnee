#!/bin/bash
set -e
CURRENT_DIR=$(dirname "$(realpath $0)")
GENERATED_DATA_DIR="${CURRENT_DIR}/../generated_data"

# Validation des données exportées
# Lancement du validateur
cd ${CURRENT_DIR}
source venv/bin/activate
python3 validate_data_with_jsonschema.py
valid=$?

if [ "$valid" = 0 ]; then
    mv ${GENERATED_DATA_DIR}/itineraires_rando.json ${GENERATED_DATA_DIR}/itineraires_rando_export.json
    echo "Fichier valide et exporté vers tools/generated_data/itineraires_rando_export.json"
else
    mv ${GENERATED_DATA_DIR}/itineraires_rando.json ${GENERATED_DATA_DIR}/itineraires_rando_notvalid.json
    echo "Fichier non valide et exporté vers tools/generated_data/itineraires_rando_not_valid.json"
fi
