#!/bin/bash

CURRENT_DIR=$(dirname "$(realpath $0)")

. ./settings.ini

###################################
### Export depuis geotrek
###################################

# Préparation de l'opération d'export depuis geotrek
# Installation du serializer geotrek

if [ "$EXPORT_GEOTREK_APP" = true ] ; then
  if [ ! -f ${CURRENT_DIR}/../1_export_geotrek_app/export_schema/config.py ]
  then
    echo "Le fichier 1_export_geotrek_app/export_schema/config.py n'existe pas"
    exit
  fi

  echo "Installation de la procédure d'export des données depuis Geotrek avec l'application Geotrek"
  sudo ln -s ${CURRENT_DIR}/../1_export_geotrek_app/export_schema /opt/geotrek-admin/var/conf/

  # Ajout du parser à Geotrek
  echo "" | sudo tee -a /opt/geotrek-admin/var/conf/parsers.py
  echo "# Serializer export schema" | sudo tee -a /opt/geotrek-admin/var/conf/parsers.py
  echo "from export_schema.custom_parser import SerializerSchemaItinerairesRando" | sudo tee -a /opt/geotrek-admin/var/conf/parsers.py
  echo "" | sudo tee -a /opt/geotrek-admin/var/conf/parsers.py
fi



###################################
### Validation des données
###################################

# Préparation de l'opération de validation d'un fichier de données

if [ "$VALIDATE" = true ] ; then
  echo "Installation de la procédure de validation des données exportées"
  cd ../2_validate_data
  python3.8 -m venv venv
  source venv/bin/activate
  pip install -r requirements.txt
  deactivate

  cd ${CURRENT_DIR}
fi



#################################
### Publication des données
#################################
# Rien à installer
