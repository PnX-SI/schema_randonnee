// Script permettant la validation :
// du schema
// des données contenues dans le fichier itineraires_rando.json

const args_file_path = process.argv.slice(2)[0];

const schema_path = '../schema.json'
const schemas_path = '../GeoJSON_schemas/'
let data_path = '../itineraires_rando.json'
if (args_file_path) {
  data_path = args_file_path
}

const Ajv = require("ajv");
const addFormats = require("ajv-formats");
const ajv = new Ajv({allErrors: true, strict: false});
addFormats(ajv);

let fs = require('fs');
const { rawListeners } = require("process");
let add_schemas = fs.readdirSync(schemas_path);


// Chargement des fichiers des sous-schemas
for (let add_schema of add_schemas) {
    path = schemas_path + add_schema
    ajv.addSchema(require(path), add_schema);
};

// Chargement du fichier principal du schéma
const schema = require(schema_path);
// Validation et chargement du schéma
try {
  var validate = ajv.compile(schema);
} catch (error) {
  throw "Schéma invalide : \n" + error.message;
}

// Test de la validité des données
try {
    const valid = validate(require(data_path));
    if (valid) console.log("Fichier de données valide !")
    else throw "Fichier de données invalide :\n" + ajv.errorsText(validate.errors, {separator: "\n"})
} catch (error) {
    console.log(error);
    process.exit(1)
}
