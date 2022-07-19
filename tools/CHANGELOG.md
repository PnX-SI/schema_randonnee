# Changelog


## Version 1.0.3 (2022-07-19)

 * Validation des données en python
 * Réorganisation des outils annexes au schéma. Tout est centralisé dans le dossier `tools`
   * 1_export_xxx : processus d'export des données
   * 2_validate_data : processus de validation des données
   * 3_publish_data_gouv_fr : processus de publication sur data.gouv.fr
   * all_export_validate_publish : processus global
     * Création d'un script permettant d'installer les différentes briques
     * Création d'un script permettant de réaliser le processus global


**⚠️ Notes de version**

Si vous utilisiez les outils d'automatisation des exports, une migration et un nettoyage des fichiers est nécessaire


 * Nettoyage et migration des fichiers de configuration de l'export des données depuis l'application geotrek

```shell
cp geotrek/export_from_django_models/export_schema/config.py tools/1_export_geotrek_app/export_schema/
rm -r  geotrek
sudo rm /opt/geotrek-admin/var/conf/export_schema
```

 * Modification du fichier de configuration :
    * Rajouter le paramètre `PRACTICE_NAME_EXCLUDE = ['Nom de pratique à exclure']`
    * Renommer le paramètre `PORTALS` en `PORTALS_NAME`
    * Renommer le paramètre `NAME_FILTER` en `TREK_NAME_EXCLUDE`
    * Renommer le paramètre `SOURCE_FILTER` en `SOURCE_NAME_EXCLUDE`



 * Nettoyage et migration des fichiers de configuration de la validation des données

```shell
rm -r local_validator
```

 * Nettoyage et migration des fichiers de configuration de la publication des données

```shell
cp data_gouv_fr/settings.ini tools/3_publish_data_gouv_fr/
rm -r data_gouv_fr
```
