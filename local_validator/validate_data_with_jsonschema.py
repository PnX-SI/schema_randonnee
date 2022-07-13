import json
from jsonschema import validate
from config import DATA_PATH, SCHEMA_PATH


with open(SCHEMA_PATH, 'r') as schema_file:
    schema = json.load(schema_file)

with open(DATA_PATH, 'r') as instance_file:
    instance = json.load(instance_file)


# If no exception is raised by validate(), the instance is valid.
validate(instance=instance, schema=schema)


# doctest: +IGNORE_EXCEPTION_DETAIL
