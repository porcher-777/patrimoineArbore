import mysql.connector
import argparse
import json
import pandas as pd
import sys

def executeRequest(request, value):
    """Fonction pour executer une requête SQL"""
    try:
        if type(value) is list:
            cursor.executemany(request, value)
        else:
            cursor.execute(request, value)
    except mysql.connector.Error as e:
        print(f"Erreur: {e}")

# Connexion a la BDD
try:
    conn = mysql.connector.connect(
            user="etu0126",
            password="kwrmdnou",
            host="localhost",
            port=3306,
            database="etu0126"
            )
except mysql.connector.Error as e:
    print(f"Erreur lors de la connexion à MariaDB: {e}")
    sys.exit(1)

# Ajout d'elements dans la BDD
cursor = conn.cursor()

# Charger les données depuis les arguments du script
parser = argparse.ArgumentParser(description="Charge les données du fichier csv dans la base de données")
parser.add_argument('csv_file', type=str, help='Fichier csv des arbres à importer dans la BDD')
args = parser.parse_args()

arbre_df = pd.read_csv(args.csv_file)

# Création de l'utilisateur ayant ajouté les arbres
cursor.executemany("INSERT INTO user (username, password) VALUES (%s, %s)", [("mickael.delaere", "1ef1edbf55183613c71eb63e85c06cfacd20e845165d08254aee49d96090748d")])

# Création des espèces
especes = [(espece,) for espece in arbre_df['fk_nomtech'].unique()]
cursor.executemany("INSERT IGNORE INTO espece (fk_espece) VALUES (%s)", especes)

# Création des états de l'arbre
etats = [(etat,) for etat in arbre_df['fk_arb_etat'].unique()]
cursor.executemany("INSERT IGNORE INTO etat (fk_etat) VALUES (%s)", etats)

# Création des secteurs
secteurs = [(secteur,) for secteur in arbre_df['clc_secteur'].unique()]
cursor.executemany("INSERT IGNORE INTO secteur (fk_secteur) VALUES (%s)", secteurs)

# Création des stade de développement
stadedevs = [(stadedev,) for stadedev in arbre_df['fk_stadedev'].unique()]
cursor.executemany("INSERT IGNORE INTO stadedev (fk_stadedev) VALUES (%s)", stadedevs)

#Création des types de pied
pieds = [(pied,) for pied in arbre_df['fk_pied'].unique()]
cursor.executemany("INSERT IGNORE INTO type_pied (fk_pied) VALUES (%s)", pieds)

# Création des types de port
ports = [(port,) for port in arbre_df['fk_port'].unique()]
cursor.executemany("INSERT IGNORE INTO type_port (fk_port) VALUES (%s)", ports)

# Création des arbres
arbres = arbre_df.to_dict(orient='records')
arbre_values = [(
    arbre['longitude'], arbre['latitude'], arbre['haut_tot'], arbre['haut_tronc'],
    arbre['tronc_diam'], arbre['fk_prec_estim'], arbre['clc_nbr_diag'],
    1 if arbre['remarquable'] else 0,  # Conversion remarquable
    arbre['fk_nomtech'], arbre['fk_port'], arbre['fk_pied'], 
    arbre['clc_secteur'], arbre['fk_arb_etat'], arbre['fk_stadedev'])
    for arbre in arbres
]

arbre_query = """
        INSERT INTO arbre (
            longitude, latitude, haut_tot, haut_tronc, tronc_diam, prec_estim, nbr_diag, 
            remarquable, date_ajout, fk_espece, fk_port, fk_pied, fk_secteur, fk_etat, fk_stadedev, username
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW(), %s, %s, %s, %s, %s, %s, "mickael.delaere")
    """
cursor.executemany(arbre_query, arbre_values)

# Commit the transaction and close the connection
conn.commit()
cursor.close()
conn.close()
