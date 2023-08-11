. parameters.txt

# Export en GeoJSON depuis la vue v_treks_schema avec ogr2ogr
ogr2ogr -f "GeoJSON" "${EXPORT_PATH}/itineraires_rando.geojson" \
    PG:"host=${DB_HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASSWORD}" \
    -nln itineraires_rando \
    -sql "select * from public.v_treks_schema"
