#!/bin/bash

############################
# Script permettant d'exporter
# depuis une base Geotrek-admin
# et de valider les données générées
CURRENT_DIR=$(dirname "$(realpath $0)")
EXPORT_PATH="../.."

# ############################
# Export des données de la base Geotrek
cd /opt/geotrek-admin/var/conf/
/usr/sbin/geotrek import SerializerSchemaItinerairesRando > ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json

date

if ! [ -s ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json ]
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
        mv ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_export.json
        echo "Fichier valide et exporté vers ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_export.json"
    else
        mv ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_notvalid.json
        echo "Fichier non valide et exporté vers ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_not_valid.json"
        echo "Voir local_validator/validation.log pour plus de détails"
    fi
fi

echo -e "\n"
