const https = require('https');

const Ajv = require("ajv/dist/2020")
const addFormats = require("ajv-formats")
const ajv = new Ajv({allErrors: true, strict: false})
addFormats(ajv)

https.get("https://json-schema.org/draft-07/schema#",(res) => {
    let body = "";

    res.on("data", (chunk) => {
        body += chunk;
    });

    res.on("end", () => {
        try {
            ajv.addMetaSchema(JSON.parse(body));
            //console.log(body)
        } catch (error) {
            console.error(error.message);
        };
    });
  }).on("error", (error) => {
    console.error(error.message);
  });

let base_url = "https://geojson.org/schema/";
let types = ["LineString.json", "MultiLineString.json", "Point.json"]

for (let type of types) {
  url = base_url + type
  https.get(url,(res) => {
    let body = "";

    res.on("data", (chunk) => {
        body += chunk;
    });

    res.on("end", () => {
        try {
            console.log(type)
            ajv.addSchema(JSON.parse(body), type);
            console.log(type)
        } catch (error) {
            console.error(error.message);
        };
    });
  }).on("error", (error) => {
    console.error(error.message);
  });
}





const schema = require('./schema.json')

/*const validate = ajv.compile(schema)

test({foo: "abc", bar: 2})
test({foo: 2, bar: 4})

function test(data) {
  const valid = validate(data)
  if (valid) console.log("Valid!")
  else console.log("Invalid: " + ajv.errorsText(validate.errors))
}*/