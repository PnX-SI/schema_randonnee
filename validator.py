##source venv/bin/activate

##pip install jschon

from jschon import Catalogue, JSON, JSONSchema, URI
from pprint import pp

catalogue = Catalogue.create_default_catalogue('2020-12')
catalogue.add_directory(URI('https://geojson.org/schema/'), './GeoJSON/')

instance_to_validate = JSON.loadf('exemple-valide.json')
print('stage 1 done')
schema = JSONSchema.loadf('schema.json')
print('stage 2 done')

pp(schema.evaluate(instance_to_validate).valid)

##pp(schema.evaluate(instance_to_validate).output('detailed'))