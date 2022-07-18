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

# ########################
# Validation des données exportées
# Lancement du validateur
cd ${CURRENT_DIR}/../../local_validator/
source venv/bin/activate
date >> validation.log
python3 validate_data_with_jsonschema.py >> validation.log
echo "\n" >> validation.log
valid=$?

if [ "$valid" != 0 ]; then
    echo  "fichier exporté vers ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_not_valid.json"
    mv ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_notvalid.json
else
    echo  "fichier exporté vers ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_export.json"
    mv ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_export.json
fi
