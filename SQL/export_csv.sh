. parameters.txt

# Création d'un environnement virtuel en Python 3
## python3 -m venv venv
## source venv/bin/activate

# Installation des dépendances
## pip install -r requirements.txt

# Export en csv depuis la vue v_treks_schema avec csvkit
sql2csv --db "postgresql://${USER}:${PASSWORD}@${DB_HOST}:${PORT}/${DB}" --query 'SELECT * FROM v_treks_schema' > ../treks.csv

# Test de la validité du schéma
frictionless validate --type schema ../schema.json

# Test de la conformité du fichier produit
frictionless validate --schema ../schema.json ../treks.csv