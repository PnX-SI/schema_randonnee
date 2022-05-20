import json
import unicodedata
from re import sub

from django.conf import settings
from django.contrib.gis.geos import GEOSGeometry
from geotrek.trekking.models import Trek

from export_schema.config import (CONTACT, DEFAULT_LICENSE, NAME_FILTER,
                                  PORTALS, SOURCE_FILTER, URL_ADMIN, URL_RANDO,
                                  limit_data, db_cat_to_schema_cat, topo_id_to_id_osm)
from export_schema.env import (django_to_schema, foreign_key_to_map, mtm_fields,
                               null_fields)


django_treks = Trek.objects.filter(
    published=True,
    source__isnull=False,
    name__isnull=False,
    practice__isnull=False,
    departure__isnull=False,
    arrival__isnull=False,
    description__isnull=False,
)

if PORTALS:
    django_treks = django_treks.filter(portal__name__in=PORTALS)
for filter in NAME_FILTER:
    django_treks = django_treks.exclude(name__icontains=filter)
for filter in SOURCE_FILTER:
    django_treks = django_treks.exclude(source__name__icontains=filter)


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

        schema_trek['medias'] = attachments


def process_geom():
    geom = GEOSGeometry(getattr(t, django_field), settings.SRID)
    geom.transform(4326)
    if django_field == 'parking_location':
        schema_trek[schema_field] = geom.wkt
    else:
        schema_trek[schema_field] = json.loads(geom.json)


def process_mtm():
    mtm_objects = getattr(t, django_field).all()
    label = mtm_fields[django_field]
    mtm_values = [getattr(a, label) for a in mtm_objects]
    if mtm_values:
        schema_trek[schema_field] = ', '.join(mtm_values)
    else:
        schema_trek[schema_field] = None


def get_url():
    name_regexed = sub(r"[^\w -]", "", t.name)
    name_stripped = name_regexed.strip()
    name_replaced = name_stripped.replace(" ", "-")
    name_unaccentuated = ''.join(c for c
                                 in unicodedata.normalize('NFD', name_replaced)
                                 if unicodedata.category(c) != 'Mn')
    name_lowered = name_unaccentuated.lower()
    schema_trek['url'] = f"https://{URL_RANDO}/trek/{t.id}-{name_lowered}"


def get_cities_info(info):
    cities_info_list = [getattr(city, info) for city in t.published_cities]
    schema_trek[schema_field] = ', '.join(cities_info_list)


schema_treks = []

for t in django_treks[:limit_data]:
    schema_trek = {}
    for django_field, schema_field in django_to_schema.items():
        if django_field in mtm_fields.keys():
            process_mtm()

        elif django_field.startswith('date'):
            schema_trek[schema_field] = str(getattr(t, django_field))[:10]

        elif django_field.startswith('cities'):
            get_cities_info(django_field[-4:])

        elif django_field in ['geom', 'parking_location'] and getattr(t, django_field):
            process_geom()

        elif django_field == 'attachments':
            transform_attachments()

        elif django_field == 'contact':
            schema_trek['contact'] = CONTACT

        elif django_field == 'url':
            get_url()

        elif django_field in null_fields:
            schema_trek[schema_field] = None

        elif django_field == 'id_osm':
            if t.id in topo_id_to_id_osm:
                schema_trek['id_osm'] = topo_id_to_id_osm[t.id]
            else:
                schema_trek['id_osm'] = None

        elif django_field in foreign_key_to_map:
            old_value = str(getattr(t, django_field))
            schema_trek[schema_field] = db_cat_to_schema_cat[django_field][old_value]

        elif django_field == 'id':
            schema_trek[schema_field] = str(getattr(t, django_field))

        elif isinstance(getattr(t, django_field), (int, float)):
            schema_trek[schema_field] = round(getattr(t, django_field))

        elif getattr(t, django_field) == None:
            schema_trek[schema_field] = None
            
        else:
            schema_trek[schema_field] = str(getattr(t, django_field))

    schema_treks.append(schema_trek)


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
