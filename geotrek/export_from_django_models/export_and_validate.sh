############################
# Script permettant d'exporter
# depuis une base geotrek-admin ayant une vue v_treks_schema
# et de valider les données générées

export EXPORT_PATH="../.."

# ############################
# Export des données de la base geotrek
geotrek import SerializerSchemaItinerairesRando > ${EXPORT_PATH}/itineraires_rando.json

# ########################
# Validation des données exportées
# Lancement du validateur
cd ../../local_validator/
node validate_data_with_ajv
valid=$?
cd ../geotrek/export_from_django_models

if [ "$valid" != 0 ]; then
    mv ${EXPORT_PATH}/itineraires_rando.json ${EXPORT_PATH}/itineraires_rando_notvalid.json
else
    mv ${EXPORT_PATH}/itineraires_rando.json ${EXPORT_PATH}/itineraires_rando_export.json
fi
