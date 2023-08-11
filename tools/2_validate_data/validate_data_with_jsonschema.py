from sys import exit
from json import load
from jsonschema.validators import Draft7Validator


with open('../../schema.json', 'r') as schema_file:
    schema = load(schema_file)

with open('../generated_data/itineraires_rando.json', 'r') as instance_file:
    instance = load(instance_file)

validator = Draft7Validator(schema)

errors = sorted(validator.iter_errors(instance), key=lambda e: e.path)

if len(errors) > 0:
    print('Fichier de données non valide :')
    for error in errors:
        nom_itineraire = (instance["features"][error.path[1]]["properties"]["nom_itineraire"])
        print(f"[{error.path[1]}], {error.path[3]}: {error.message} - ({nom_itineraire})")
    exit(1)
else:
    print("Fichier de données valide !")
