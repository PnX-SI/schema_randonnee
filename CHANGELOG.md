# Changelog


## Version 1.0.3 (unreleased)

 * Réorganisation des outils annexes au schéma. Tout est centralisé dans le dossier `tools`
   * 1_export_xxx : processus d'export des données
   * 2_validate_data : processus de validation des données
   * 3_publish_data_gouv_fr : processus de publication sur data.gouv.fr
   * all_export_validate_publish : processus global
 * Création d'un script permettant d'installer les différentes briques
 * Création d'un script permettant de réaliser le processus global


**⚠️ Notes de version**

Si vous utilisez les outils d'automatisation des exports, une migration et un nettoyage des fichiers est nécessaire


 * Nettoyage et migration des fichiers de configuration de l'export des données depuis l'application geotrek

```shell
cp geotrek/export_from_django_models/export_schema/config.py tools/1_export_geotrek_app/export_schema/
rm -r  geotrek
rm /opt/geotrek-admin/var/conf/export_schema
```

 * Nettoyage et migration des fichiers de configuration de la validation des données

 * Nettoyage et migration des fichiers de configuration de la publication des données

## Version 1.0.2 (2021-10-11)

- Changement du nom du schéma en "Itinéraires de randonnées"
- Changement du nom de la propriété `proprietaire` en `producteur`
- Réorganisation de la documentation

## Version 1.0.1 (2021-08-29)

Suppression du schéma externe `https://geojson.org/schema/Point.json`, plus utilisé depuis l'aplatissement de l'objet parking

## Version 1.0.0 (2021-08-05)

Correction du JSON Schema :
- itineraire_parent : type integer à string
- parking : aplatissement de l'objet en deux parking_info et parking_geometrie (format WKT)
- medias[url] : changement de l'exemple, ajout format uri et required
- plusieurs champs : ajout de descriptions, changement de titres
- plusieurs champs : ajout de type "null" possible
- eid : changement nom pour id_local et type int à string
- cotation : champ supprimé
- instructions : modification du titre
- pdipr_inscription : ajout
- pdipr_date_inscription : ajout

## Version 0.3.1 - (unreleased)

Correction du JSON Schema :

- duree : passage de `"integer"` à `"number"`
- itineraire_parent : ajout de `"type": "null"`
- cotation : ajout valeur `""`

## Version 0.3.0

Rétrogradation du schéma en version `[draft-07](https://json-schema.org/specification-links.html#draft-7)`

## Version 0.2.1

Correction du JSON Schema :

- ajout des `"type": "null"` pour les champs non obligatoires
- correction de `"oneOf": [{"$ref": "point"},"null"` en `"oneOf": [{"$ref": "point"},{"type": "null"}`
- déplacement d'une accolade qui excluait la majorité des champs de l'objet `properties_randonnee`

## Version 0.2.0

Passage au format JSON Schema

Champs modifiés :

- id_source : nom
- sources : nom, passage en chaîne de caractères
- pratique : ajout de valeurs
- type : nom, ajout de valeurs
- communes : passage en chaîne de caractères
- balisage : passage en chaîne de caractères
- difficulté : changement de la définition
- description_courte : presentation_courte
- description : presentation
- themes : passage en chaîne de caractères
- parking : passage en feature GeoJSON avec une propriété infos_parking, une géométrie
- medias : ajout d'une propriété type_media
- rando_parent : itineraire_parent
- type_sol : passage en chaîne de caractères

Champs ajoutés :

- cotation : cotation technique (ex-difficulté)

Champs supprimés :

- structure

## Version 0.1.2

Complétion des métadonnées.

Champs modifiés :

- sources : passage en array
- balisage : changement de la définition
- difficulté : complétion de l'échelle
- geometrie : passage en WKT
- geometrie_parking : passage en WKT

Champs ajoutés :

- instructions : ancien champ balisage
- type_sol : array des types de sol de la randonnée

## Version 0.1.1

Publication initiale.
