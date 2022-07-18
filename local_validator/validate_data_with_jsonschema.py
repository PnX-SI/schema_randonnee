import json
import jsonschema
from config import DATA_PATH, SCHEMA_PATH


with open(SCHEMA_PATH, 'r') as schema_file:
    schema = json.load(schema_file)

with open(DATA_PATH, 'r') as instance_file:
    instance = json.load(instance_file)

validator = jsonschema.Draft7Validator(schema)

errors = sorted(validator.iter_errors(instance), key=lambda e: e.path)

if len(errors) > 0:
    print('Fichier de données non valide :')
    for error in errors:
        nom_itineraire = (instance["features"][error.path[1]]["properties"]["nom_itineraire"])
        print(f"[{error.path[1]}], {error.path[3]}: {error.message} - ({nom_itineraire})")
        #print(list(error.schema_path), error.message, sep=", ")
else:
    print("Fichier de données valide !")
