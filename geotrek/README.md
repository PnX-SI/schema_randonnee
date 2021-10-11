# Geotrek

Le Parc national des Écrins et le Parc national des Cévennes, entre autres, utilisent l'application [Geotrek](https://github.com/GeotrekCE) pour gérer leurs itinéraires de randonnée et les publier sur leur site internet. Une vue PostgreSQL (`v_treks_schema.sql`) est disponible dans le dossier `geotrek`. Elle permet de formater des itinéraires issus de Geotrek pour qu'ils soient directement compatibles avec le schéma de données.

Il est nécessaire d'adapter cette vue selon la construction des données Geotrek de votre structure.

Vue testée avec `PostgreSQL 10.17` / `PostGIS 2.4.3` / `unaccent 1.1` / `Geotrek-admin 2.62.0`

Un script shell `geotrek/export_geojson.sh` permet d'exporter les données de la vue `geotrek/v_treks_schema.sql` au format GeoJSON avec `ogr2ogr (GDAL v2.2.3)`.

Pour des tests de validité plus fluides des données exportées de Geotrek, l'exécution du script `geotrek/export_and_validate.sh` permet :

- l'exécution de `geotrek/export_geojson.sh`
- la copie du fichier `itineraires_rando.geojson` et son renommage en `itineraires_rando.json`
- l'exécution du script `local_validator/validate_data_with_ajv.js` sur `itineraires_rando.json` et l'affichage du résultat dans la console.
