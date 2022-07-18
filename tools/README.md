# Publication de données selon le standard itinéraires de randonnées

La publication se fait en trois étapes :
 * Export des données
 * Validation
 * Publication

Actuellement, les implémentations disponibles dans ce dépot le sont pour la plateformme geotrek et data.gouv pour l'export.

Les différentes étapes sont implémentées et utilisables de façon indépendantes, le dossier all_export_validate_publish permet de combiner les actions.

Une procédure d'installation globale est disponible en bas du document : [procédure d'installation](#Installation)


# Export des données depuis Geotrek

Deux moyens sont proposés pour exporter les données depuis Geotrek dans un fichier conforme au schéma.

## Export via l'application Geotrek

Disponible dans le dossier `export_from_django_models`, ce script s'intègre à Geotrek et utilise les modèles Django pour exporter les itinéraires depuis la base de données. Placé directement dans le contexte de l'application Geotrek-admin, il n'a pas besoin de paramètres de connexion à la base de données, et permet une personnalisation aisée.

### Avantages
 - la personnalisation se fait dans un fichier à part et est beaucoup plus aisée à réaliser
 - le script est mieux intégré à Geotrek
 - le maintien du script est plus aisé car celui-ci est séparé en trois fichiers aux fonctions distinctes
 - ne nécessite aucun module externe, tous les modules sont natifs de Python ou Django

### Inconvénients
 - le langage Python peut être moins accessible
 - les champs tels que `type_sol` et `pdipr_inscription` (pas encore gérés par la vue SQL) sont peut-être moins rapidement calculables avec cette méthode qu'avec la vue SQL (ORM au lieu de pur SQL)


## Vue PostgreSQL (Non maintenu)
Disponible dans le dossier `export_from_SQL_view` (`v_treks_schema.sql`), elle permet de formater des itinéraires issus de Geotrek pour qu'ils soient directement compatibles avec le schéma de données. Il est nécessaire de l'adapter selon la construction des données Geotrek de votre structure.
Des scripts shell permettent d'exporter les données de la vue au format GeoJSON.

### Avantages
 - accessible techniquement (SQL et script bash juste pour l'export)
 - des champs tels que `type_sol` et `pdipr_inscription` seront peut-être plus rapidement calculables avec cette méthode (requêtes en pur SQL au lieu de passer par un ORM)
### Inconvénients
 - la personnalisation se fait directement dans le fichier principal (la vue), complexifiant les mises à jour
 - tout se fait dans le même fichier, le rendant assez complexe à débugger et maintenir
 - nécessite de stocker ses identifiants de connexion à la base de données en clair
 - nécessite l'installation d'une extension tierce (unaccent)


# Validation

# Publication

La publication des données, correspond au téléversement du fichier exporté sur une plateformme de données ouverte. Nous avons choisi d'implémenter la publication sur la plateformme de l'étalab data.gouv.

En amont de la publication il faut avoir sur la plateformme data.gouv avoir créer un compte et un jeu de données. La documentation est accessible en ligne : [https://doc.data.gouv.fr/]


# Installation globale

### Prérequis

 * Python3

```shell
 apt install python3 python3-venv
```

### Configuration
Chaque dossier posède son propre fichier de configuration. Il faut les créer et les modifier en fonction des modules que vous souhaitez activer.


```shell
# Fichier de configuration globale permettant d'activer les modules
cp all_export_validate_publish/settings.ini.sample all_export_validate_publish/settings.ini
# Configuration de l'export des données depuis l'application geotrek
cp 1_export_geotrek_app/export_schema/config.py.sample config.py
# Validation des données exportées
cp 2_validate_data/config.py.sample 2_validate_data/config.py
# Publication des données sur la plateformme data gouv
cp 3_publish_data_gouv_fr/settings.ini.sample 3_publish_data_gouv_fr/settings.ini
```