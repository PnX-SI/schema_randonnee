import sys
import json
import jsonschema


with open('../../schema.json', 'r') as schema_file:
    schema = json.load(schema_file)

with open('../generated_data/itineraires_rando.json', 'r') as instance_file:
    instance = json.load(instance_file)

validator = jsonschema.Draft7Validator(schema)

errors = sorted(validator.iter_errors(instance), key=lambda e: e.path)

if len(errors) > 0:
    print('Fichier de données non valide :')
    for error in errors:
        nom_itineraire = (instance["features"][error.path[1]]["properties"]["nom_itineraire"])
        print(f"[{error.path[1]}], {error.path[3]}: {error.message} - ({nom_itineraire})")
    sys.exit(1)
else:
    print("Fichier de données valide !")
