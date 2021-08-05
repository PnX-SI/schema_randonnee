// Script permettant la validation :
// du schema
// des données contenues dans le fichier itineraires_rando.json

const schema_path = '../schema.json'
const schemas_path = '../GeoJSON_schemas/'
const data_path = '../itineraires_rando.json'

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
// Chargement et test de la validité du fichier de données
try {
  const validate = ajv.compile(schema);
  test_data(require(data_path), validate);
} catch (error) {
  console.error("Schéma invalide : \n", error.message)
}

function test_data(data, validate) {
  // Execution du test de la validité des données
  const valid = validate(data);

  if (valid) console.log("Fichier de données valide !")
  else console.error("Fichier de données invalide :\n" + ajv.errorsText(validate.errors, {separator: "\n"}))
};