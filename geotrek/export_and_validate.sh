############################
# Script permettant d'exporter
# depuis une base (géotrek) ayant une vue v_treks_schema
# et de valider les données générées

. parameters.txt

# ############################
# Export des données de la base geotrek
bash export_geojson.sh

# ########################
# Validation des données exportées

# Changement d'exension en json car geojson n'est pas reconnu par ajv
cp ${EXPORT_PATH}/treks.geojson treks.json

# Lancement du validateur
cd ../local_validator/
node ajv.js
