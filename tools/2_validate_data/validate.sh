#!/bin/bash


CURRENT_DIR=$(dirname "$(realpath $0)")


date

if ! [ -s ${CURRENT_DIR}/itineraires_rando.json ]
then
     echo "Le fichier est vide, un problème est survenu lors de l'export depuis Geotrek"
else
    # ########################
    # Validation des données exportées
    # Lancement du validateur
    cd ${CURRENT_DIR}/../../local_validator/
    source venv/bin/activate
    date >> validation.log
    python3 validate_data_with_jsonschema.py >> validation.log
    valid=$?
    echo -e "\n" >> validation.log


    if [ "$valid" = 0 ]; then
        mv ${CURRENT_DIR}/itineraires_rando.json ${CURRENT_DIR}/itineraires_rando_export.json
        echo "Fichier valide et exporté vers ${CURRENT_DIR}/itineraires_rando_export.json"
    else
        mv ${CURRENT_DIR}/itineraires_rando.json ${CURRENT_DIR}/itineraires_rando_notvalid.json
        echo "Fichier non valide et exporté vers ${CURRENT_DIR}/itineraires_rando_not_valid.json"
        echo "Voir local_validator/validation.log pour plus de détails"
    fi
fi

echo -e "\n"
