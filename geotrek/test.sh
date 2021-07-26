bash export_geojson.sh
cp treks.geojson ../
mv ../treks.geojson ../exemple-valide.json 
cd ../local_validator
node ajv.js