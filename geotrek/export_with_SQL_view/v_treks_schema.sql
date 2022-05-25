-- testé avec : Schéma de données 1.0.2 / PostgreSQL 12.9 / PostGIS 3.0.0 / unaccent 1.1 / Geotrek-admin 2.81.0

-- CREATE EXTENSION IF NOT EXISTS unaccent;

DROP VIEW IF EXISTS v_treks_schema;

CREATE VIEW v_treks_schema AS
WITH
    -- Constantes à adapter à votre contexte
    constants AS (
        SELECT
            'https://urlduportailgeotrekrando/' AS url_rando,
            'https://urlduportailgeotrekadmin/' AS url_admin,
            'contact@structure.fr' AS contact,
            'CC-BY-SA-ND' AS default_licence
    ),
    -- Liste des identifiants des relations OpenStreetMap des randonnées si elles existent
    osm AS (
        SELECT * FROM (VALUES
          --(904197,12076664), -- Exemple d'une randonnée et sa relation dans OSM
          (null::int,null::int)
          ) AS liste (trek_id,id_osm)
    ),
    -- Liste des itinéraires, à adapter à votre contexte si vous souhaitez les filtrer
    selected_t AS (
        SELECT *
        FROM trekking_trek t
        JOIN core_topology ct ON ct.id = t.topo_object_id
        WHERE t.published IS true and ct.deleted = false
    ),
    sources AS (
        SELECT string_agg(c_1."name", ',')::text AS noms_source, t_1.trek_id -- création d'une chaîne de caractères de toutes les sources de l'itinéraire
        FROM common_recordsource c_1, trekking_trek_source t_1
        WHERE t_1.recordsource_id = c_1.id
        GROUP BY t_1.trek_id
        ),
    handi AS (
        SELECT string_agg(a."name", ',') AS liste, a_s.trek_id
        FROM trekking_accessibility a
        JOIN trekking_trek_accessibilities a_s ON a.id = a_s.accessibility_id
        JOIN selected_t t ON  t.topo_object_id = a_s.trek_id
        GROUP BY a_s.trek_id
        ),
    themes AS (
        SELECT string_agg(c_1.LABEL, ',') AS liste, t_1.trek_id
        FROM common_theme c_1
        JOIN trekking_trek_themes t_1 ON  c_1.id = t_1.theme_id
        JOIN selected_t t ON  t.topo_object_id = t_1.trek_id
        GROUP BY t_1.trek_id
        ),
    medias AS (
        SELECT
            c_1.object_id,
            jsonb_agg(
                (jsonb_build_object
                    ('type_media',
                        CASE
                            WHEN c_1.is_image IS TRUE THEN 'image'
                            WHEN f."type" IN ('Vidéo', 'Audio') THEN unaccent(lower(f."type"))
                            WHEN c_1.attachment_file ILIKE '%.pdf' THEN 'pdf'
                            ELSE 'autre'
                        END,
                    'url', COALESCE(
                        (SELECT url_admin FROM constants LIMIT 1) || 'media/' || NULLIF(c_1.attachment_file, ''),
                        NULLIF(c_1.attachment_link, ''),
                        c_1.attachment_video
                    ),
                    'titre', c_1.legend,
                    'auteur', c_1.author,
                    'licence', (SELECT default_licence FROM constants LIMIT 1))
                )
            ) AS liste
        FROM trekking_trek t
        JOIN common_attachment c_1 ON t.topo_object_id = c_1.object_id
        JOIN common_filetype f ON f.id = c_1.filetype_id
        GROUP BY c_1.object_id
        ),
    balisage AS (
        SELECT string_agg(net.network, ',') AS b, tnet.trek_id
        FROM trekking_treknetwork net
        JOIN trekking_trek_networks tnet ON tnet.treknetwork_id = net.id
        JOIN selected_t t ON t.topo_object_id = tnet.trek_id
        GROUP BY tnet.trek_id
        ),
    tp AS (
        SELECT practice."name" as practice_name, cirkwi."name" as cirkwi_name, practice.id
        FROM trekking_practice practice
        LEFT JOIN cirkwi_cirkwilocomotion cirkwi ON cirkwi.id = practice.cirkwi_id
        ),
    parent AS (
        SELECT string_agg(o.parent_id::text, ',') AS liste, t.topo_object_id
        FROM trekking_orderedtrekchild o
        JOIN selected_t t ON t.topo_object_id = o.child_id
        GROUP BY t.topo_object_id
        )
SELECT
    t.topo_object_id::varchar(250) AS id_local,
    sources.noms_source AS producteur,
    (SELECT contact FROM constants LIMIT 1) AS contact, -- adresse mail à renseigner dans les constantes
    top.uuid AS uuid, -- UUID disponibles depuis la version 2.70.0 de Geotrek-admin
    -- Construction de l'url valable pour Geotrek-rando V2 (voir juste en-dessous pour l'url V3)
    (SELECT url_rando FROM constants LIMIT 1) || lower(unaccent(replace(tp.practice_name, ' ', '-'))) || '/'
    || lower(unaccent(replace(btrim(regexp_replace(t."name", '[^\w -]', '', 'g')), ' ', '-'))) || '/' AS url,
    -- Construction de l'url valable pour Geotrek-rando V3 :
    -- (SELECT url_rando FROM constants LIMIT 1) || 'trek/' || t.topo_object_id || '-' || replace(btrim(regexp_replace(t."name", '[^\d\w,()]', '', 'g')), ' ', '-') AS url,
    osm.id_osm,
    t."name" AS nom_itineraire,
    tp.practice_name AS pratique, -- uniquement valable si vos noms de pratiques correspondent déjà au schéma, sinon passer par quelque chose comme : CASE WHEN tp.practice_name ILIKE 'Randonnée Trail' THEN 'trail'::text END AS pratique
    lower(route.route::text) AS type_itineraire, -- idem que pour les pratiques, uniquement valable si vos noms de types d'itinéraires correspondent déjà au schéma, sinon passer par un CASE WHEN
    c.liste_noms::text AS communes_nom,
    c.liste_codes::text AS communes_code,
    btrim(t.departure) AS depart,
    btrim(t.arrival) AS arrivee,
    t.duration::real AS duree,
    balisage.b::text AS balisage,
    top.length::integer AS longueur,
    difficulty.difficulty AS difficulte,
    top.max_elevation AS altitude_max,
    top.min_elevation AS altitude_min,
    top.ascent AS denivele_positif,
    top.descent AS denivele_negatif,
    t.description AS instructions,
    t.ambiance AS presentation,
    t.description_teaser AS presentation_courte,
    themes.liste::text AS themes,
    t.advice AS recommandations,
    handi.liste::text AS accessibilite,
    t.access AS acces_routier,
    t.public_transport AS transports,
    advised_parking AS parking_info,
    -- Reprojection des géométries en 4326
    ST_AsText(st_transform(parking_location, 4326)) AS parking_geometrie,
    date(top.date_insert)::text AS date_creation,
    date(top.date_update)::text AS date_modification,
    medias.liste AS medias,
    parent.liste::text AS itineraire_parent,
    NULL::text AS type_sol,
    NULL::boolean AS pdipr_inscription,
    NULL::text AS pdipr_date_inscription,
    -- Reprojection des géométries en 4326
    st_transform(top.geom, 4326) AS geom
FROM selected_t t
JOIN core_topology top ON t.topo_object_id = top.id
LEFT JOIN sources ON t.topo_object_id = sources.trek_id
JOIN tp ON tp.id = t.practice_id
LEFT JOIN osm ON t.topo_object_id = osm.trek_id
LEFT JOIN trekking_route route ON t.route_id = route.id
LEFT JOIN trekking_difficultylevel difficulty ON difficulty.id = t.difficulty_id
LEFT JOIN handi ON t.topo_object_id = handi.trek_id
LEFT JOIN parent ON t.topo_object_id = parent.topo_object_id
LEFT JOIN themes ON t.topo_object_id = themes.trek_id
LEFT JOIN medias ON t.topo_object_id = medias.object_id
LEFT JOIN balisage ON t.topo_object_id = balisage.trek_id
LEFT JOIN LATERAL ( -- construction des listes des noms de commune et des codes INSEE
    SELECT string_agg(z."name", ',') AS liste_noms, string_agg(z.code, ',') AS liste_codes, c_1.id
    FROM core_topology c_1
    JOIN zoning_city z ON t.topo_object_id = c_1.id AND st_intersects(c_1.geom, z.geom)
    GROUP BY c_1.id
) c ON true;
