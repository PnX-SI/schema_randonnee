# Validateur

Le script [validate_data_with_jsonschema.py](./validate_data_with_jsonschema.py) permet de valider un fichier JSON contre un JSON schema. Le validateur ne fonctionne pas avec l'extension `.geojson`, mais un simple changement d'extension en `.json` suffit.

### Configuration

Copier le fichier `config.py.sample` en `config.py` si ce n'est pas déjà fait.
Renseigner les paramètres suivants si besoin :
 - `DATA_PATH` : le chemin relatif du fichier à valider (par défaut `./../itineraires_rando.json`, soit la racine du dépôt)
 - `SCHEMA_PATH` : le chemin relatif du schéma contre lequel valider le fichier (par défaut `../../schema.json`, soit la racine du dépôt)

### Fonctionnement
Le script [](validate.sh) active l'environnement virtuel Python, exécute le script Python de validation, puis renomme en `itineraires_rando_export.json` le fichier s'il est conforme au schéma, ou en `itineraires_rando_notvalid.json` s'il ne l'est pas. Ce script shell ne fonctionne que si `itineraires_rando.json` existe à la racine du dépôt local.
Un fichier de log avec le résultat de la validation est créé dans le dossier `2_validate_data`.

Pour valider un fichier ayant un nom personnalisé ou bien ne se trouvant pas à la racine, il faut modifier le fichier de configuration et lancer directement le script Python en ayant activé l'environnement virtuel. Aucun log ne sera créé.
