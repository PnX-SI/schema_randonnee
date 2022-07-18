#!/bin/bash

CURRENT_DIR=$(dirname "$(realpath $0)")

# Validation des données exportées
# Lancement du validateur
cd ${CURRENT_DIR}
source venv/bin/activate
date >> validation.log
python3 validate_data_with_jsonschema.py >> validation.log
valid=$?
echo "" >> validation.log

if [ "$valid" = 0 ]; then
    mv ${CURRENT_DIR}/../../itineraires_rando.json ${CURRENT_DIR}/../../itineraires_rando_export.json
    echo "Fichier valide et exporté vers schema_randonnee/itineraires_rando_export.json"
else
    mv ${CURRENT_DIR}/../../itineraires_rando.json ${CURRENT_DIR}/../../itineraires_rando_notvalid.json
    echo "Fichier non valide et exporté vers schema_randonnee/itineraires_rando_not_valid.json"
    echo "Voir 2_validate_data/validation.log pour plus de détails"
fi

echo ""
