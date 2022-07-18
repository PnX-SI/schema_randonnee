
CURRENT_DIR=$(dirname "$(realpath $0)")

###################################
### Export depuis geotrek
###################################

# Copie le fichier de configuration
cp ${CURRENT_DIR}/config/config_export.py ${CURRENT_DIR}/../geotrek/geotrek_from_django_models/export_schema/config.py

# Préparation de l'opération d'export depuis geotrek
# Installation du serializer geotrek
sudo ln -s ${CURRENT_DIR}/../geotrek/export_from_django_models/export_schema /opt/geotrek-admin/var/conf/

# Ajout du parseur
sudo su
echo "" >> /opt/geotrek-admin/var/conf/parsers.py
echo "# Serializer export schema" >> /opt/geotrek-admin/var/conf/parsers.py
echo "from export_schema.custom_parser import SerializerSchemaItinerairesRando" >> /opt/geotrek-admin/var/conf/parsers.py
echo "" >> /opt/geotrek-admin/var/conf/parsers.py
exit



###################################
### Validation des données
###################################

# Copie le fichier de configuration
cp ${CURRENT_DIR}/config/config_validate.py ${CURRENT_DIR}/../local_validator/config.py

# Préparation de l'opération d'export depuis geotrek
cd ../local_validator
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate

cd ${CURRENT_DIR}

#################################
### Publication des données
#################################

# copie du fichier de configuration
cp ${CURRENT_DIR}/config/settings_data_gouv.ini.sample ${CURRENT_DIR}/../data_gouv_fr/settings_data_gouv.ini
