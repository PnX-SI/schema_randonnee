# Configuration

## Fichier `config.py.sample`
Renseigner tous les paramètres :
 - `URL_ADMIN` : URL du Geotrek-admin
 - `URL_RANDO` : URL du Geotrek-rando associé
 - `CONTACT` : adresse mél de contact de l'organisation publicatrice des données
 - `DEFAULT_LICENSE` : licence attribuée par défaut à tous les médias exportés
 - `PORTALS` : liste des portails dont on veut exporter les itinéraires (non requis)
 - `NAME_FILTER` : liste des chaînes de caractère utilisées pour filtrer les itinéraires par leur nom (par exemple `'®'` pour exclure tous les itinéraires dont le nom contient ce symbole) (non requis)
 - `SOURCE_FILTER` : liste des chaînes de caractère utilisées pour filtrer les itinéraires par leur source (non requis)
 - `db_cat_to_schema_cat` : mise en correspondance des catégories de la base de données avec la liste des catégories autorisées par le schéma
 - `topo_id_to_id_osm` : mise en correspondance des identifiants des itinéraires avec l'identifiant de la relation OpenStreetMap correspondante (non requis)

 Renommer le fichier `config.py.sample` en `config.py`

## Fichier `env.py`
 - `django_to_schema` : détermine l'ordre de traitement des champs, correspond à l'ordre défini dans le schéma. Met en correspondance nom des champs Django et nom des champs du schéma, pour les champs existant dans Django.
 - `m2m_fields` : recense les champs Django de type clef étrangère ManyToMany ou ManyToOne, qui nécessitent un traitement particulier, notamment grâce au nom du champ qui contient la valeur que l'on cherche à récupérer (name, network, label, id...)
 - `foreign_key_to_map` : recense les champs Django de type clef étrangère dont on souhaite modifier les valeurs grâce à la correspondance avec les listes de valeur issues du schéma
 - `null_fields` : champs absents tel quels du modèle Django, et qui nécessiteraient un traitement plus poussé. En attendant, ces champs seront créés avec une valeur nulle

# Utilisation
Faire un lien du dossier `export_schema` à l'emplacement suivant : `/opt/geotrek-admin/var/conf/`
``` sh
sudo ln -s geotrek/export_from_django_models/export_schema /opt/geotrek-admin/var/conf/
```

Ajouter la classe suivante au fichier `geotrek-admin/var/conf/parsers.py` :
``` python
    from export_schema.custom_parser import SerializerSchemaItinerairesRando
```

Celle-ci est aussi disponible dans le fichier `export_schema/custom_parser.py`.

Dans un terminal, lancer la commande `geotrek import SerializerSchemaItinerairesRando > itineraires_rando.json` pour exporter le résultat dans un fichier JSON. Cette commande est utilisable telle quelle dans une tâche cron.

Pour des tests de validité plus fluides des données exportées de Geotrek, l'exécution du script `export_and_validate.sh` permet :
- l'exécution de `geotrek import SerializerSchemaItinerairesRando`
- la création d'un fichier `itineraires_rando.json` à la racine du répertoire `schema_randonnee` (paramètre modifiable dans le script bash)
- l'exécution du script `local_validator/validate_data_with_ajv.js` sur `itineraires_rando.json`
- si le fichier est conforme au schéma, il est renommé en `itineraires_rando_export.json`, et en `itineraires_rando_notvalid.json` s'il ne l'est pas.


# Fonctionnement du script

Le script crée une sélection des itinéraires en interrogeant le modèle Django `Trek`. Plusieurs filtres sont appliqués pour ne conserver que les itinéraires correspondant aux contraintes du schéma (certains champs doivent être renseignés) et de l'organisation (portails, noms ou sources à exclure).

Pour chaque itinéraire de cette sélection, une boucle est lancée sur chaque champd du dictionnaire `django_to_schema` pour alimenter un dictionnaire `schema_treks` dont les champs correspondent au schéma (ordre, nom et valeurs). Plusieurs conditions permettent d'adapter le traitement à chaque catégorie de champ (numéraire, date, etc).

La structure du JSON est ensuite créée, puis remplie avec le contenu du dictionnaire `schema_treks`, et enfin imprimée pour permettre son écriture dans un fichier JSON.

