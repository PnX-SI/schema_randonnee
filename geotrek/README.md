# Geotrek

Le Parc national des Écrins et le Parc national des Cévennes, entre autres, utilisent l'application [Geotrek](https://github.com/GeotrekCE) pour gérer leurs itinéraires de randonnée et les publier sur leur site internet.
Deux moyens sont proposés pour exporter les données depuis Geotrek dans un fichier conforme au schéma.

## Vue PostgreSQL
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

## Export via Django

Disponible dans le dossier `export_from_django_models`, ce script s'intègre à Geotrek et utilise les modèles Django pour exporter les itinéraires depuis la base de données. Placé directement dans le contexte de l'application Geotrek-admin, il n'a pas besoin de paramètres de connexion à la base de données, et permet une personnalisation aisée.

### Avantages
 - la personnalisation se fait dans un fichier à part et est beaucoup plus aisée à réaliser
 - le script est mieux intégré à Geotrek
 - le maintien du script est plus aisé car celui-ci est séparé en trois fichiers aux fonctions distinctes
 - ne nécessite aucun module externe, tous les modules sont natifs de Python ou Django

### Inconvénients
 - le langage Python peut être moins accessible
 - les champs tels que `type_sol` et `pdipr_inscription` (pas encore gérés par la vue SQL) sont peut-être moins rapidement calculables avec cette méthode qu'avec la vue SQL (ORM au lieu de pur SQL)
