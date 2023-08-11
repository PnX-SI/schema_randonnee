############################
# Script permettant d'exporter
# depuis une base geotrek-admin ayant une vue v_treks_schema
# et de valider les données générées

. parameters.txt

# ############################
# Export des données de la base geotrek
bash export_geojson.sh

# ########################
# Validation des données exportées

# Changement d'extension en JSON car GeoJSON n'est pas reconnu par ajv
cp ${EXPORT_PATH}/itineraires_rando.geojson ../../itineraires_rando.json

# Lancement du validateur
cd ../../local_validator/
node validate_data_with_ajv
