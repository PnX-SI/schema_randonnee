import json
import unicodedata
from re import sub

from django.conf import settings
from django.contrib.gis.geos import GEOSGeometry
from geotrek.trekking.models import Trek

from export_schema.config import (CALCUL_TYPE_SOL, CONTACT,
                                  DB_CAT_TO_SCHEMA_CAT, DEFAULT_LICENSE,
                                  LIMIT_DATA, PORTALS_NAME,
                                  PRACTICE_NAME_EXCLUDE, SOURCE_NAME_EXCLUDE,
                                  TOPO_ID_TO_ID_OSM, TREK_NAME_EXCLUDE,
                                  URL_ADMIN, URL_RANDO)
from export_schema.env import (django_to_schema, foreign_key_to_map,
                               m2m_fields, null_fields)

django_treks = Trek.objects.filter(
    published=True,
    source__isnull=False,
    name__isnull=False,
    practice__isnull=False,
    departure__isnull=False,
    arrival__isnull=False,
    description__isnull=False,
)

# print(django_treks)

if PORTALS_NAME:
    django_treks = django_treks.filter(portal__name__in=PORTALS_NAME)
for filter in TREK_NAME_EXCLUDE:
    django_treks = django_treks.exclude(name__icontains=filter)
for filter in SOURCE_NAME_EXCLUDE:
    django_treks = django_treks.exclude(source__name__icontains=filter)
for filter in PRACTICE_NAME_EXCLUDE:
    django_treks = django_treks.exclude(practice__name__icontains=filter)

# print(django_treks)
    
def transform_attachments():
    if t.attachments:
        attachments = []
        for att in t.attachments.all():
            attachment = {}
            attachment['auteur'] = att.author
            attachment['titre'] = att.legend
            attachment['url'] = f'https://{URL_ADMIN}/{str(att.attachment_file)}'
            attachment['licence'] = DEFAULT_LICENSE

            if att.is_image:
                attachment['type_media'] = 'image'
            elif str(att.attachment_file).endswith('pdf'):
                attachment['type_media'] = 'pdf'
            elif att.filetype == 'Vidéo':
                attachment['type_media'] = 'video'
            elif att.filetype == 'Audio':
                attachment['type_media'] = 'audio'
            else:
                attachment['type_media'] = 'autre'

            attachments.append(attachment)

        return attachments


def process_geom():
    geom = GEOSGeometry(getattr(t, django_field), settings.SRID)
    geom.transform(4326)
    if django_field == 'parking_location':
        return geom.wkt
    else:
        return json.loads(geom.json)


def process_m2m():
    m2m_objects = getattr(t, django_field).all()
    label = m2m_fields[django_field]
    m2m_values = [getattr(a, label) for a in m2m_objects]
    if m2m_values:
        return ', '.join(m2m_values)


def get_url():
    name_regexed = sub(r"[^\w -]", "", t.name)
    name_stripped = name_regexed.strip()
    name_replaced = name_stripped.replace(" ", "-")
    name_unaccentuated = ''.join(c for c
                                 in unicodedata.normalize('NFD', name_replaced)
                                 if unicodedata.category(c) != 'Mn')
    name_lowered = name_unaccentuated.lower()

    return f"https://{URL_RANDO}/trek/{t.id}-{name_lowered}"


def get_cities_info(info):
    cities_info_list = [getattr(city, info) for city in t.published_cities]
    return ', '.join(cities_info_list)


def get_types_sol():
    trek_paths = [agg.path for agg in t.aggregations.all()]
    types_sols = []
    for trek_path in trek_paths:
        physical_edges_types = [agg.topo_object.physicaledge.name
                                for agg in trek_path.aggregations.all()
                                if agg.topo_object.kind == 'PHYSICALEDGE']
        types_sols.extend(physical_edges_types)

    if len(set(types_sols)) > 0:
        return ', '.join(set(types_sols))


schema_treks = []

for t in django_treks[:LIMIT_DATA]:
    schema_trek = {}
    for django_field, schema_field in django_to_schema.items():
        if django_field in m2m_fields.keys():
            schema_trek[schema_field] = process_m2m()

        elif django_field.startswith('date'):
            schema_trek[schema_field] = str(getattr(t, django_field))[:10]

        elif django_field.startswith('cities'):
            schema_trek[schema_field] = get_cities_info(django_field[-4:])

        elif django_field in ['geom', 'parking_location'] and getattr(t, django_field):
            schema_trek[schema_field] = process_geom()

        elif django_field == 'attachments':
            schema_trek['medias'] = transform_attachments()

        elif django_field == 'contact':
            schema_trek['contact'] = CONTACT

        elif django_field == 'url':
            schema_trek['url'] = get_url()

        elif django_field == 'type_sol':
            schema_trek['type_sol'] = get_types_sol() if CALCUL_TYPE_SOL else None

        elif django_field in null_fields:
            schema_trek[schema_field] = None

        elif django_field == 'id_osm':
            if t.id in TOPO_ID_TO_ID_OSM:
                schema_trek['id_osm'] = TOPO_ID_TO_ID_OSM[t.id]
            else:
                schema_trek['id_osm'] = None

        elif django_field in foreign_key_to_map:
            old_value = str(getattr(t, django_field))
            schema_trek[schema_field] = DB_CAT_TO_SCHEMA_CAT[django_field][old_value]

        elif django_field == 'id':
            schema_trek[schema_field] = str(getattr(t, django_field))

        elif isinstance(getattr(t, django_field), (int, float)):
            schema_trek[schema_field] = round(getattr(t, django_field))

        elif getattr(t, django_field) is None:
            schema_trek[schema_field] = None

        else:
            schema_trek[schema_field] = str(getattr(t, django_field))

    schema_treks.append(schema_trek)
    
# print(schema_treks)

featurecollection = {
    "type": "FeatureCollection",
    "name": "itineraires_rando",
    "crs": {
        "type": "name",
        "properties": {"name": "urn:ogc:def:crs:OGC:1.3:CRS84"},
    },
    "features": [],
}


for trek in schema_treks:
    feature = {
        "type": "Feature",
        "properties": {k: v for k, v in trek.items() if k != 'geom'},
        "geometry": trek['geom'],
    }
    featurecollection["features"].append(feature)

json_object = json.dumps(featurecollection, ensure_ascii=False)

print(json_object)
