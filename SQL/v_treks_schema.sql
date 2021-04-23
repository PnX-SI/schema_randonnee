-- compatibilités : PostgreSQL 10.16 / PostGIS 2.4 / Geotrek-admin 2.?? / Schéma de données 0.1.2
DROP VIEW IF EXISTS v_treks_schema;
CREATE VIEW v_treks_schema AS
WITH
    selected_t AS (
        SELECT *
        FROM trekking_trek t
        WHERE t.published IS TRUE AND t.name !~~ '%®%'
    ),
    sources AS (
        SELECT json_agg(json_build_object('nom', c_1.name, 'contact', c_1.website))::text AS liste, t_1.trek_id -- création d'une array JSON des sources de la randonnée (il peut y en avoir plusieurs), transtypage en texte nécessaire pour que l'export avec csvkit ne change pas tous les colons
        FROM common_recordsource c_1, trekking_trek_source t_1
        WHERE t_1.recordsource_id = c_1.id
        AND c_1.name::text !~~ '%randonnée pédestre%'::text -- filtrage des données dont la source est la FFR ou un de ses comités départementaux pour des raisons de droit
        GROUP BY t_1.trek_id
        ),
    handi AS (
        SELECT json_agg(a.name) as liste, a_s.trek_id
        FROM trekking_accessibility a
        JOIN trekking_trek_accessibilities a_s ON a.id = a_s.accessibility_id
        JOIN selected_t t ON  t.topo_object_id = a_s.trek_id
        GROUP BY a_s.trek_id
        ),
    themes AS (
        SELECT json_agg(c_1.label) AS liste, t_1.trek_id
        FROM common_theme c_1
        JOIN trekking_trek_themes t_1 ON  c_1.id = t_1.theme_id
        JOIN selected_t t ON  t.topo_object_id = t_1.trek_id
        GROUP BY t_1.trek_id
        ),
    medias AS (
        SELECT json_agg(json_build_object('url', c_1.attachment_file, 'titre', c_1.legende, 'auteur', c_1.auteur, 'licence', 'licence')) AS liste, c_1.object_id
        FROM common_attachment c_1
        JOIN selected_t t ON t.topo_object_id = c_1.object_id
        GROUP BY c_1.object_id
        ),
    balisage AS (
        SELECT json_agg(net.network) AS b, tnet.trek_id
        FROM trekking_treknetwork net
        JOIN trekking_trek_networks tnet ON tnet.treknetwork_id = net.id
        JOIN selected_t t ON t.topo_object_id = tnet.trek_id
		GROUP BY tnet.trek_id
        ),
    sol AS (
        SELECT json_agg(t_1.name) AS liste, e.topo_object_id
        FROM land_physicaledge e
        JOIN land_physicaltype t_1 ON e.physical_type_id = t_1.id
        JOIN selected_t t ON t.topo_object_id =  e.topo_object_id
        GROUP BY e.topo_object_id
        )
SELECT t.topo_object_id AS id_source,
    json_build_object('nom', ats.name, 'contact', 'contact@cevennes-parcnational.fr')::text AS structure, -- transtypage en texte nécessaire pour csvkit
    CASE -- comme la source de la donnée est requise par le schéma, si elle est absente, alors le nom de la structure productrice du jeu de données est inséré
       WHEN sources.liste IS NULL THEN '[' || json_build_object('nom', ats.name, 'contact', 'contact@cevennes-parcnational.fr')::text || ']' -- transtypage en texte nécessaire pour csvkit
       ELSE sources.liste::text
    END AS sources,
    NULL::text AS url, -- pas d'url stockée dans la BDD, à recréer dynamiquement
    NULL AS uuid,
    t.name AS nom,
    CASE -- appel à plusieurs tables pour répartir les randonnées selon le bon type de pratique. Spécifique au PNC car une catégorie 'VTT/équestre' est à séparer
        WHEN t.route_id = 4 THEN 'equestre'::text
        WHEN t.practice_id = 1 AND t.route_id <> 4 THEN 'VTT'::text
        ELSE 'pedestre'::text
    END AS pratique,
    CASE -- si route=itinérance et départ != arrivée (casse et espaces en début et fin de chaîne mis à part) alors aller simple, sinon si équestre ou itinérance alors boucle, sinon valeur de la BDD
        WHEN t.route_id = 3 AND btrim(t.departure) !~~* btrim(t.arrival) THEN 'aller simple'::text		
        WHEN t.route_id = 4 OR t.route_id = 3 THEN 'boucle'::text
        ELSE lower(route.route::text)
    END AS type,
    c.liste::text AS communes,
    btrim(t.departure) AS depart,
    btrim(t.arrival) AS arrivee,
    round(t.duration::numeric,1)::real AS duree,
    balisage.b::text AS balisage,
    round((top.length/1000)::numeric, 1)::real AS longueur,
    CASE -- choix arbitraires de conversion de l'échelle de difficulté du PNC dans les échelles du CAS, de la FFC et de la FFVélo, à adapter à chaque structure
    	WHEN balisage.b::text ~~* '%VTT noir%' THEN 'noir'
  		WHEN balisage.b::text ~~* '%VTT rouge%' THEN 'rouge'
  		WHEN balisage.b::text ~~* '%VTT bleu%' THEN 'bleu'
 		WHEN balisage.b::text ~~* '%VTT vert%' THEN 'vert'
		WHEN t.route_id = 4 THEN ''
		WHEN t.practice_id = 1 AND t.difficulty_id = 5 THEN 'noir'::text
        WHEN t.practice_id = 1 AND (t.difficulty_id = ANY (ARRAY[3, 4])) THEN 'rouge'::text
        WHEN t.practice_id = 1 AND t.difficulty_id = 2 THEN 'bleu'::text
        WHEN t.practice_id = 1 AND t.difficulty_id = 1 THEN 'vert'::text
        WHEN (t.practice_id = ANY (ARRAY[3, 4, 5])) AND t.difficulty_id = 5 THEN 'T2'::text
        WHEN (t.practice_id = ANY (ARRAY[3, 4, 5])) AND t.difficulty_id < 5 THEN 'T1'::text
        ELSE ''::text
    END AS difficulte,
    top.max_elevation AS altitude_max,
    top.min_elevation AS altitude_min,
    top.ascent AS denivele_positif,
    top.descent AS denivele_negatif,
    t.description_teaser AS description_courte,
    CASE -- ambiance parfois manquante alors que le champ description est requis par le schéma
        WHEN (t.ambiance = ''::text) IS NOT FALSE THEN t.description_teaser
        ELSE t.ambiance
    END AS description,
    t.description AS instructions,
    themes.liste::text AS themes,
    t.advice AS recommandations,
    handi.liste::text AS accessibilite,
    t.access AS acces_routier,
    t.public_transport AS transports,
      -- réduction de la précision des coordoonnées à 5 décimales, simplification de la géométrie pour réduire le nombre de points. Poids de la géométrie divisé par 7.5, et nécessaire pour ne pas dépasser la limite de 110 000 caractères par champ d'un csv (le validateur frictionless du schéma a aussi cette limite). Ce traitement suffit pour des itinéraires de moins de 200km en montagne
    st_astext(st_simplifypreservetopology(st_snaptogrid(st_transform(top.geom, 4326), 0.000027::double precision), 0.000027::double precision)) AS geometrie,
    t.advised_parking AS parking,
    st_astext(st_snaptogrid(st_transform(t.parking_location, 4326), 0.000027::double precision)) AS geometrie_parking,
    date(top.date_insert) AS date_creation,
    date(top.date_update) AS date_modification,
    medias.liste::text AS medias,
    parent.parent_id AS rando_parent,
    sol.liste::text AS type_sol
    
FROM selected_t t

LEFT JOIN core_topology top ON t.topo_object_id = top.id
LEFT JOIN sources ON t.topo_object_id = sources.trek_id
LEFT JOIN authent_structure ats ON ats.id = t.structure_id
LEFT JOIN trekking_route route ON t.route_id = route.id
LEFT JOIN handi ON t.topo_object_id = handi.trek_id
LEFT JOIN trekking_orderedtrekchild parent ON t.topo_object_id = parent.child_id
LEFT JOIN themes ON t.topo_object_id = themes.trek_id
LEFT JOIN medias ON t.topo_object_id = medias.object_id
LEFT JOIN LATERAL (
    SELECT json_agg(json_build_object('nom', z.name, 'code_INSEE', z.code)) AS liste, c_1.id
    FROM core_topology c_1
    JOIN zoning_city z ON t.topo_object_id = c_1.id AND st_intersects(c_1.geom, z.geom)
    GROUP BY c_1.id
    ) c ON true
LEFT JOIN balisage ON t.topo_object_id = balisage.trek_id
LEFT JOIN sol ON t.topo_object_id = sol.topo_object_id;