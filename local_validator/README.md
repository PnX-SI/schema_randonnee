# Validateur

Un script Node.js utilisant [ajv](https://ajv.js.org/) permet de valider un fichier JSON contre le schéma `schema.json` tout en utilisant les schémas GeoJSON stockés dans `GeoJSON_schemas/`. Le validateur ne fonctionne pas avec les extensions `.geojson`, mais un simple changement d'extension en `.json` suffit.

### Configuration

Le script `validate_data_with_ajv.js` accepte le chemin absolu du fichier JSON à valider comme argument. En l'absence de cet argument, c'est le fichier `itineraires_rando.json` situé à la racine du dossier `schema_randonnee`qui sera validé.


### Prérequis

- `Node.js 16.15.0`
- `npm 8.5.5`

### Installation

Pour une installation automatique des packages nécessaires, exécuter la commande  `npm install` dans le dossier `local_validator`.

Pour une installation manuelle :
```
npm install ajv
npm install ajv-formats
```

### Utilisation

Exécution du script :
```
node validate_data_with_ajv.js /absolute/path/to/file.json
```

Sortie :

`Fichier de données valide !`

### GitHub Action workflow

Un workflow permet d'effectuer un essai de validation à chaque push de `schema.json` ou `exemple-valide.json`. C'est un dernier test qui assure de manière publique que la dernière version du schéma ou d'un exemple soient bien valides. Une GitHub Action a été créée pour l'occasion à partir du script de validation ajv, elle permet contrairement aux actions existantes de gérer des sous-schémas : [jsonschema_validator](https://github.com/pnx-si/jsonschema_validator).
