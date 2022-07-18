# Fonctionnement (non maintenu)

Vue testée avec `Schéma de données 1.0.2` / `PostgreSQL 12.9` / `PostGIS 3.0.0` / `unaccent 1.1` / `Geotrek-admin 2.81.0`

Le fichier `parameters.txt.sample` doit être renommé en `parameters.txt` et ses différentes variables, qui permettente la connexion à la base de données, renseignées.

Un script shell `export_geojson.sh` permet d'exporter les données de la vue `v_treks_schema.sql` au format GeoJSON avec `ogr2ogr (GDAL v2.2.3)`.

Pour des tests de validité plus fluides des données exportées de Geotrek, l'exécution du script `export_and_validate.sh` permet :

- l'exécution de `export_geojson.sh`
- la copie du fichier `itineraires_rando.geojson` et son renommage en `itineraires_rando.json`
- l'exécution du script `local_validator/validate_data_with_ajv.js` sur `itineraires_rando.json` et l'affichage du résultat dans la console.
