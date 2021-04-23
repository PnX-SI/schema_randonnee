-- les champs qui contiennent du json sont formatés en texte pour faciliter l'export en csv par la suite
CREATE TABLE schema_donnees (
id_source text,
structure text, --json
sources text, --json
url text,
uuid text,
nom text,
pratique text,
type text,
communes text, --json
depart text,
arrivee text,
duree real,
balisage text, --json
longueur real,
difficulte text,
altitude_max integer,
altitude_min integer,
denivele_positif integer,
denivele_negatif integer,
description_courte text,
description text,
instructions text,
themes text, --json
recommandations text,
accessibilite text, --json
acces_routier text,
transports text,
geometrie text,
parking text,
geometrie_parking text,
date_creation date,
date_modification date,
medias text, --json
rando_parent text,
type_sol text --json
)