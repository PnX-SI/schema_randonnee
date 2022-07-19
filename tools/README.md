# Publication de données selon le standard itinéraires de randonnée

La publication se fait en trois étapes :
 * Export des données
 * Validation
 * Publication

Actuellement, deux implémentations sont disponibles dans ce dépôt pour l'export depuis le logiciel Geotrek, et une implémentation est disponible pour la publication vers data.gouv.fr.

Les différentes étapes sont implémentées et utilisables de façon indépendante et le dossier `all_export_validate_publish` contient des scripts et instructions pour les combiner.

Une procédure d'installation globale est disponible en bas de ce document : [procédure d'installation](#installation-globale). Elle permet d'installer les outils voulus (export, validation, publication). Elle est accompagnée d'un script permettant d'enchaîner toutes les étapes activées, de l'export jusqu'à la publication.
Pour l'utiliser, se référer à la documentation d'[utilisation du script global](#utilisation-du-script-global)


# Export des données depuis Geotrek

Deux moyens sont proposés pour exporter les données depuis Geotrek dans un fichier conforme au schéma.
Pour effectuer cette étape, se référer à la documentation spécifique :
  * Export via l'application geotrek : [1_export_geotrek_app/README.md](./1_export_geotrek_app/README.md)
  * Export via une vue SQL : [1_export_geotrek_SQL_view/README.md](./1_export_geotrek_SQL_view/README.md)
Les avantages et inconvénients des deux méthodes sont décrits ci-dessous :

## Export via l'application Geotrek

Disponible dans le dossier [](./1_export_geotrek_app), ce script s'intègre à Geotrek et utilise les modèles Django pour exporter les itinéraires depuis la base de données. Placé directement dans le contexte de l'application Geotrek-admin, il n'a pas besoin de paramètres de connexion à la base de données, et permet une personnalisation aisée.

### Avantages
 - la personnalisation se fait dans un fichier à part et est beaucoup plus aisée à réaliser
 - le script est mieux intégré à Geotrek
 - le maintien du script est plus aisé car celui-ci est séparé en trois fichiers aux fonctions distinctes
 - ne nécessite aucun module externe, tous les modules sont natifs de Python ou Django

### Inconvénients
 - le langage Python peut être moins accessible
 - les champs tels que `type_sol` et `pdipr_inscription` (pas gérés par la vue SQL) sont peut-être moins rapidement calculables avec cette méthode qu'avec la vue SQL (ORM au lieu de pur SQL)


## Export via une vue PostgreSQL (non maintenu)
Disponible dans le dossier à l'adresse [/1_export_geotrek_SQL_view/v_treks_schema.sql](1_export_geotrek_SQL_view/v_treks_schema.sql), cette vue permet de formater des itinéraires issus de Geotrek pour qu'ils soient directement compatibles avec le schéma de données. Il est nécessaire de l'adapter selon la construction des données Geotrek de votre structure.
Des scripts shell permettent d'exporter les données de la vue au format GeoJSON.

### Avantages
 - accessible techniquement (SQL et script bash juste pour l'export)
 - des champs tels que `type_sol` et `pdipr_inscription` seront peut-être plus rapidement calculables avec cette méthode, mais pas encore gérés (requêtes en pur SQL au lieu de passer par un ORM)
### Inconvénients
 - la personnalisation se fait directement dans le fichier principal (la vue), complexifiant les mises à jour
 - tout se fait dans le même fichier, le rendant assez complexe à débugger et maintenir
 - nécessite de stocker ses identifiants de connexion à la base de données en clair
 - nécessite l'installation d'une extension tierce (`unaccent`)

# Validation

L'étape de validation d'un fichier de données permet de vérifier la conformité de celui-ci par rapport au schéma avant sa publication en ligne. Cette étape est nécessaire pour assurer la qualité de la donnée publiée.

Pour effectuer cette étape, se référer à la documentation spécifique : [2_validate_data/README.md](./2_validate_data/README.md)



# Publication

La publication des données correspond au téléversement du fichier exporté sur une plateforme de donnée ouverte. Nous avons choisi d'implémenter la publication sur la plateforme d'Etalab data.gouv.fr

En amont de la publication il faut avoir créé sur la plateforme data.gouv un compte et un jeu de données. La documentation est accessible en ligne : https://doc.data.gouv.fr/



Pour effectuer cette étape, se référer à la documentation spécifique : [3_publish_data_gouv_fr/README.md](./3_publish_data_gouv_fr/README.md)


# Installation globale


## Prérequis

 * Python3

```shell
 apt install python3 python3-venv
```

## Configuration

**Activation des modules**

Un fichier de configuration globale permet d'activer les modules à installer, executer

```shell
cp all_export_validate_publish/settings.ini.sample all_export_validate_publish/settings.ini
```

Paramètres:

| Nom                 | Valeur          |  Description                                                   |
| :------------------ |:--------------- | :------------------------------------------------------------- |
| EXPORT_GEOTREK_APP  |  true/false     |  Activation du module d'export des données depuis geotrek      |
| VALIDATE            |  true/false     |  Activation du module de validation des données                |
| PUBLISH_DATA_GOUV   |  true/false     |  Activation du module de publication des données sur data.gouv |


**Configuration de chaque module**


Les étapes d'export et de publication possèdent leur propre fichier de configuration. Il faut les créer et les modifier à partir des fichiers examples `.sample` en fonction des modules que vous souhaitez activer.


 * Configuration de l'export des données depuis l'application geotrek :
```shell
cp 1_export_geotrek_app/export_schema/config.py.sample 1_export_geotrek_app/export_schema/config.py
```
Documentation complète des paramètres : [1_export_geotrek_app/README.md](./1_export_geotrek_app/README.md)


 * Configuration de la publication des données sur la plateforme data.gouv :
```shell
cp 3_publish_data_gouv_fr/settings.ini.sample 3_publish_data_gouv_fr/settings.ini
```

Documentation complète des paramètres : [1_export_geotrek_app/README.md](./1_export_geotrek_app/README.md)
## Installation

Après avoir modifié les fichiers de configuration il faut exécuter la commande suivante :
``` shell
cd all_export_validate_publish
./install.sh
```

## Utilisation du script global

Le script global s'exécute en utilisateur `root` avec la commande suivante :
``` shell
sudo ./export_validate_and_publish.sh
```

Il est possible de configurer la table des crons pour qu'il s'exécute automatiquement :

```sh
# Exemple : tous les lundis à 5 heures du matin
0 5 * * 1 root /MY_PATH/schema_randonnee/tools/all_export_validate_publish/export_validate_and_publish.sh
```

Le logging n'est pas proposé nativement, mais chacun des scripts comporte tous les `echo` et `print` nécessaires pour un logging de qualité. Exemple :
```sh
0 5 * * 1 root /MY_PATH/schema_randonnee/tools/all_export_validate_publish/export_validate_and_publish.sh >> /MY_PATH/schema_randonnee/tools/generated_data/export_validate_publish.log
```
