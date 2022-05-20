django_to_schema = {
    'id': 'id_local',
    'source': 'producteur',
    'contact': 'contact',
    'uuid': 'uuid',
    'url': 'url',
    'id_osm': 'id_osm',
    'name': 'nom_itineraire',
    'practice': 'pratique',
    'route': 'type_itineraire',
    'cities_name': 'communes_nom',
    'cities_code': 'communes_code',
    'departure': 'depart',
    'arrival': 'arrivee',
    'duration': 'duree',
    'networks': 'balisage',
    'length': 'longueur',
    'difficulty': 'difficulte',
    'max_elevation': 'altitude_max',
    'min_elevation': 'altitude_min',
    'ascent': 'denivele_positif',
    'descent': 'denivele_negatif',
    'description': 'instructions',
    'ambiance': 'presentation',
    'description_teaser': 'presentation_courte',
    'themes': 'themes',
    'advice': 'recommandations',
    'accessibility_infrastructure': 'accessibilite',
    'access': 'acces_routier',
    'public_transport': 'transports_commun',
    'advised_parking': 'parking_info',
    'parking_location': 'parking_geometrie',
    'date_insert': 'date_creation',
    'date_update': 'date_modification',
    'attachments': 'medias',
    'parents': 'itineraire_parent',
    'type_sol': 'type_sol',
    'pdipr_inscription': 'pdipr_inscription',
    'pdipr_date_inscription': 'pdipr_date_inscription',
    'geom': 'geom',
}

mtm_fields = {
    'source': 'name',
    'networks': 'network',
    'themes': 'label',
    'parents': 'id',
}

foreign_key_to_map = ['route', 'practice']

null_fields = [
    'type_sol',
    'pdipr_inscription',
    'pdipr_date_inscription',
]

