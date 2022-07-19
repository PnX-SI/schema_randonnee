# Validateur

Le script [validate_data_with_jsonschema.py](./validate_data_with_jsonschema.py) permet de valider un fichier JSON contre un JSON schema. Le validateur ne fonctionne pas avec l'extension `.geojson`, mais un simple changement d'extension en `.json` suffit.

## Fonctionnement
Le script [validate.sh](validate.sh) active l'environnement virtuel Python, exécute le script Python de validation (qui utilise la librairie [jsonschema](https://python-jsonschema.readthedocs.io/en/stable/)), puis renomme en `itineraires_rando_export.json` le fichier s'il est conforme au schéma, ou en `itineraires_rando_notvalid.json` s'il ne l'est pas. Ce script shell ne fonctionne que si `itineraires_rando.json` existe dans le dossier [`tools/generated_data`](../generated_data/).
Un fichier de log avec le résultat de la validation est créé dans le dossier `tools/generated_data/`.

Pour valider un fichier ayant un nom personnalisé ou bien ne se trouvant pas dans le bon répertoire, il faut modifier le script Python et le lancer directement en ayant activé l'environnement virtuel. Aucun log ne sera créé.
