. parameters.txt

# Export en GeoJSON depuis la vue v_treks_schema avec ogr2ogr
ogr2ogr -f "GeoJSON" "treks.geojson" PG:"host=${DB_HOST} user=${USER} dbname=${DB} password=${PASSWORD}" -nln treks -sql "select * from public.v_treks_schema"