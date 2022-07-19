#!/bin/bash
set -e

############################
# Script permettant d'exporter
# depuis une base Geotrek-admin
# et de valider les données générées
CURRENT_DIR=$(dirname "$(realpath $0)")
EXPORT_PATH="../generated_data"

# ############################
# Export des données de la base Geotrek
cd /opt/geotrek-admin/var/conf/
/usr/sbin/geotrek import SerializerSchemaItinerairesRando > ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json

date

if ! [ -s ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json ]
then
    echo "Le fichier est vide, un problème est survenu lors de l'export depuis Geotrek"
    mv ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_notvalid.json
    echo "Fichier non valide et exporté vers tools/generated_data/itineraires_rando_not_valid.json"
    exit 1
else
  echo "Le fichier de données a été exporté vers tools/generated_data/itineraires_rando.json"
  exit 0
fi
