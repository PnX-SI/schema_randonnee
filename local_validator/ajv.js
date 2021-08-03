const schema_path = '../schema.json'
const schemas_path = '../GeoJSON_schemas/'
const data_path = '../itineraires_rando.json'

const Ajv = require("ajv");
const addFormats = require("ajv-formats");
const ajv = new Ajv({allErrors: true, strict: false});
addFormats(ajv);

let fs = require('fs');
let add_schemas = fs.readdirSync(schemas_path);

for (let add_schema of add_schemas) {
    path = schemas_path + add_schema
    ajv.addSchema(require(path), add_schema);
};

const schema = require(schema_path);
const validate = ajv.compile(schema);

test(require(data_path));

function test(data) {
  const valid = validate(data);
  if (valid) console.log("Valide !")
    else console.log("Invalide :\n" + ajv.errorsText(validate.errors, {separator: "\n"}))
};