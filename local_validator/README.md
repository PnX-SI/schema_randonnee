# Validateur

Un script Node.js utilisant [ajv](https://ajv.js.org/) permet de valider le fichier `itineraires_rando.json` (à produire) contre le schéma `schema.json` tout en utilisant les schémas GeoJSON stockés dans `GeoJSON_schemas/`. Le validateur ne fonctionne pas avec les extensions `.geojson`, mais un simple changement d'extension en `.json` suffit.

### Prérequis

- `Node.js 16.5.0`
- `npm 7.20.1`

### Commandes

```
npm install ajv
npm install ajv-formats
```

```
cd local_validator
node validate_data_with_ajv.js
```

Output:

`Fichier de données valide !`

### GitHub Action workflow

Un workflow permet d'effectuer un essai de validation à chaque push de `schema.json` ou `exemple-valide.json`. C'est un dernier test qui assure de manière publique que la dernière version du schéma ou d'un exemple soient bien valides. Une GitHub Action a été créée pour l'occasion à partir du script de validation ajv, elle permet contrairement aux actions existantes de gérer des sous-schémas : [jsonschema_validator](https://github.com/pnx-si/jsonschema_validator).
