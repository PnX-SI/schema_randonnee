# Publication de données selon le standard itinéraires de randonnée

La publication se fait en trois étapes :
 * Export des données
 * Validation
 * Publication

Actuellement, deux implémentations sont disponibles dans ce dépôt pour l'export depuis le logiciel Geotrek, et une implémentation est disponible pour la publication vers data.gouv.fr.

Les différentes étapes sont implémentées et utilisables de façon indépendante et le dossier `all_export_validate_publish` contient des scripts et instructions pour les combiner.

Une procédure d'installation globale est disponible en bas de ce document : [procédure d'installation](#Installation).


# Export des données depuis Geotrek

Deux moyens sont proposés pour exporter les données depuis Geotrek dans un fichier conforme au schéma :

## Export via l'application Geotrek

Disponible dans le dossier `1_export_geotrek_app`, ce script s'intègre à Geotrek et utilise les modèles Django pour exporter les itinéraires depuis la base de données. Placé directement dans le contexte de l'application Geotrek-admin, il n'a pas besoin de paramètres de connexion à la base de données, et permet une personnalisation aisée.

### Avantages
 - la personnalisation se fait dans un fichier à part et est beaucoup plus aisée à réaliser
 - le script est mieux intégré à Geotrek
 - le maintien du script est plus aisé car celui-ci est séparé en trois fichiers aux fonctions distinctes
 - ne nécessite aucun module externe, tous les modules sont natifs de Python ou Django

### Inconvénients
 - le langage Python peut être moins accessible
 - les champs tels que `type_sol` et `pdipr_inscription` (pas gérés par la vue SQL) sont peut-être moins rapidement calculables avec cette méthode qu'avec la vue SQL (ORM au lieu de pur SQL)


## Export via une vue PostgreSQL (non maintenu)
Disponible dans le dossier `1_export_geotrek_SQL_view` (`v_treks_schema.sql`), elle permet de formater des itinéraires issus de Geotrek pour qu'ils soient directement compatibles avec le schéma de données. Il est nécessaire de l'adapter selon la construction des données Geotrek de votre structure.
Des scripts shell permettent d'exporter les données de la vue au format GeoJSON.

### Avantages
 - accessible techniquement (SQL et script bash juste pour l'export)
 - des champs tels que `type_sol` et `pdipr_inscription` seront peut-être plus rapidement calculables avec cette méthode, mais pas encore gérés (requêtes en pur SQL au lieu de passer par un ORM)
### Inconvénients
 - la personnalisation se fait directement dans le fichier principal (la vue), complexifiant les mises à jour
 - tout se fait dans le même fichier, le rendant assez complexe à débugger et maintenir
 - nécessite de stocker ses identifiants de connexion à la base de données en clair
 - nécessite l'installation d'une extension tierce (`unaccent`)

Pour effectuer cette étape, se référer à la documentation spécifique : (./1_export_geotrek_app/README.md) ou (./1_geotrek_SQL_view/README.md)

# Validation

L'étape de validation d'un fichier de données contre le schéma avant sa publication en ligne est nécessaire pour s'assurer de sa conformité. Le script `2_validate_data/validate.sh` permet de valider un fichier JSON contre le schéma `schema.json`.

Pour effectuer cette étape, se référer à la documentation spécifique : (#2_validate_data/README.md)



# Publication

# Installation

## Installation des modules

### Export geotrek app



### Export geotrek views

### Validation des données

### Publication des données

## Installation globale

### Configuration
Chaque dossier posède son propre fichier de configuration. Il faut les créer en fonction des modules que vous souhaitez activer.
