# Installation

La procédure d'installation de ce module est intégrée au script [`all_export_validate_publish/install.sh`](../all_export_validate_publish/install.sh). Les instructions sont disponibles ici : [../README.md#installation-globale](../README.md#installation-globale)

# Configuration

Si ce n'est pas déjà fait, copier le fichier [`export_schema/config.py.sample`](./export_schema/config.py.sample) en `config.py`.

## Fichier `config.py`
Renseigner tous les paramètres :
 - `URL_ADMIN` : URL du Geotrek-admin
 - `URL_RANDO` : URL du Geotrek-rando associé
 - `CONTACT` : adresse mél de contact de l'organisation publicatrice des données
 - `DEFAULT_LICENSE` : licence attribuée par défaut à tous les médias exportés
 - `PORTALS_NAME` : liste des noms des portails dont on veut exporter les itinéraires
 - `TREK_NAME_EXCLUDE` : liste des chaînes de caractère utilisées pour filtrer les itinéraires par leur nom (par exemple `'®'` pour exclure tous les itinéraires dont le nom contient ce symbole)
 - `SOURCE_NAME_EXCLUDE` : liste des chaînes de caractère utilisées pour filtrer les itinéraires par leur source
 - `PRACTICE_NAME_EXCLUDE` : liste des chaînes de caractère utilisées pour filtrer les itinéraires par leur pratique
 - `DB_CAT_TO_SCHEMA_CAT` : mise en correspondance des catégories de la base de données avec la liste des catégories autorisées par le schéma
 - `TOPO_ID_TO_ID_OSM` : mise en correspondance des identifiants des itinéraires avec l'identifiant de la relation OpenStreetMap correspondante (non requis)
 - `CALCUL_TYPE_SOL` : si `True`, active le calcul des types de voie (`physicaledge`) présents sur l'itinéraire et renseigne le champ `type_sol` du schéma avec la liste de ceux-ci. /!\ Par défaut, les types de voie dans Geotrek ont plutôt des valeurs comme "Piste" et "Sentier", ce qui ne correspond pas à la description du champ `type_sol`. Si, comme au Parc national des Cévennes, vous avez détourné cet usage pour stocker des revêtements ("Cailloux", "Herbe"), alors ce paramètre peut être pertinent. Désactivé par défaut car allonge énormément la génération du fichier JSON.
 - `LIMIT_DATA` : utile seulement en phase de test, pour limiter le nombre d'itinéraires à exporter dans le fichier JSON afin d'accélérer sa génération et son ouverture. Doit être un entier ou prendre la valeur `None`

## Fichier `env.py`
Aucune intervention manuelle n'est nécessaire sur ce fichier. Voilà cependant une explication des variables :
 - `django_to_schema` : détermine l'ordre de traitement des champs, correspond à l'ordre défini dans le schéma. Met en correspondance nom des champs Django et nom des champs du schéma, pour les champs existant dans Django.
 - `m2m_fields` : recense les champs Django de type clef étrangère ManyToMany ou ManyToOne, qui nécessitent un traitement particulier, notamment grâce au nom du champ qui contient la valeur que l'on cherche à récupérer (name, network, label, id...)
 - `foreign_key_to_map` : recense les champs Django de type clef étrangère dont on souhaite modifier les valeurs grâce à la correspondance avec les listes de valeur issues du schéma
 - `null_fields` : champs absents tel quels du modèle Django, et qui nécessiteraient un traitement plus poussé. En attendant, ces champs seront créés avec une valeur nulle

# Utilisation
Le lancement de l'export se fait via le script [all_export_validate_publish/export_validate_and_publish.sh](../all_export_validate_publish/export_validate_and_publish.sh), instructions disponibles ici : [all_export_validate_publish/README.md](../README.md#utilisation-du-script-global).

Pour rester à jour avec les évolutions du schéma et du processus d'export, il suffira ensuite de lancer `git pull origin`. Le fichier `config.py` ne sera pas écrasé, et le lien symbolique créé automatiquement dans `/opt/geotrek-admin/var/conf/` vers le dossier `export_schema` ne sera pas cassé. Si une tâche automatique type `cron` est paramétrée, l'opération de mise à jour du dépôt local ne devrait pas engendrer de rupture de fonctionnement, sauf en cas de nouvelles versions du schéma ou du modèle de données Geotrek non rétro-compatibles.

# Fonctionnement du script

Le script crée une sélection des itinéraires en interrogeant le modèle Django `Trek`. Plusieurs filtres sont appliqués pour ne conserver que les itinéraires correspondant aux contraintes du schéma (certains champs doivent être renseignés) et de l'organisation (portails, noms ou sources à exclure).

Pour chaque itinéraire de cette sélection, une boucle est lancée sur chaque champ du dictionnaire `django_to_schema` pour alimenter un dictionnaire `schema_treks` dont les champs correspondent au schéma (ordre, nom et valeurs). Plusieurs conditions permettent d'adapter le traitement à chaque catégorie de champ (numéraire, date, etc).

La structure du JSON est ensuite créée, puis remplie avec le contenu du dictionnaire `schema_treks`, et enfin imprimée pour permettre son écriture dans un fichier JSON.
