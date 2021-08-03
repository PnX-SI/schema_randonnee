. parameters.txt

# Export en GeoJSON depuis la vue v_treks_schema avec ogr2ogr
ogr2ogr -f "GeoJSON" "${EXPORT_PATH}/treks.geojson" \
    PG:"host=${DB_HOST} port=${PORT} dbname=${DB} user=${USER} password=${PASSWORD}" \
    -nln treks \
    -sql "select * from public.v_treks_schema"
