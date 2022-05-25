############################
# Script permettant d'exporter
# depuis une base geotrek-admin ayant une vue v_treks_schema
# et de valider les données générées
CURRENT_DIR=$(dirname "$(realpath $0)")
EXPORT_PATH="../.."

# ############################
# Export des données de la base geotrek
cd /opt/geotrek-admin/var/conf/
geotrek import SerializerSchemaItinerairesRando > ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json

# ########################
# Validation des données exportées
# Lancement du validateur
cd ${CURRENT_DIR}/../../local_validator/
nvm use
node validate_data_with_ajv ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json
valid=$?

if [ "$valid" != 0 ]; then
    mv ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_notvalid.json
else
    mv ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando.json ${CURRENT_DIR}/${EXPORT_PATH}/itineraires_rando_export.json
fi
