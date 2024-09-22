# Traitement des données

import pandas as pd
from sklearn.preprocessing import LabelEncoder, MinMaxScaler
import numpy as np
from scipy.stats import f_oneway
from itertools import combinations
from scipy.stats.mstats import winsorize
import joblib
import json
import argparse

# Visualisations

import matplotlib.pyplot as plt
import seaborn as sns

# Apprentissage

from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsRegressor
from sklearn.ensemble import GradientBoostingRegressor, RandomForestRegressor

# Métriques

from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error
from sklearn.model_selection import GridSearchCV

# ------------------------------ Model -------------------------------------------------------

# Chargement du modèle complet

model = joblib.load('Besoin_client_2/best_model.pkl')
encoder = joblib.load('Besoin_client_2/label_encoders.pkl')
normaliser = joblib.load('Besoin_client_2/normalizers.pkl')

# ----------------------------- Header ---------------------------------------------------

# --- encNorm --------------------------------------------------------------
# Encodage des données qualitatives et normalisation des données quantitatives.
# \param arbres_data_qual (df), liste des colonnes qualitatives
# \param arbres_data_quant (df), liste des colonnes quantitatives
# \no return

def encNorm(arbres_data_qual, arbres_data_quant):

    # Encodage des variables qualitatives
    
    for col, enc in encoder.items():
        arbres_data_qual[col] = enc.fit_transform(arbres_data_qual[col])
    
    # Normalisation des variables quantitatives
    
    for col, norm in normaliser.items():
        arbres_data_quant[col] = norm.fit_transform(arbres_data_quant[[col]])


# --- encNormInv --------------------------------------------------------------
# Encodage et normalisation inverse des 'estim_age' prédits par le modèle.
# \param data_pred (df), équivalent à y_test_pred, les données prédites verbeuses / au format de base
# \no return

def encNormInv(data_pred):

    # Encodage inverse
    
    for col in interesting_cols_qual:
        data_pred[col] = encoder[col].inverse_transform(data_pred[col])
    
    
    # Normalisation inverse
    
    for col in interesting_cols_quant:
        data_pred[[col]] = normaliser[col].inverse_transform(data_pred[[col]])


# --- init --------------------------------------------------------------
# Chargement des données, séparation de celles-ci selon leur type. Elles sont encodées et normalisées puis on sélectionne les colonnes utiles et centre # les valeurs aberrantes.
# \param filename (str), le nom du fichier contenant la base à traiter
# \return preprocessed_data_abber (df), les données encodées et normalisées débarassées des valeurs aberrantes

def init(arbres_data):

    # Déclaration des variables globales utilisées dans encNormInv

    global interesting_cols_quant 
    global interesting_cols_qual

    # Séparation des données 

    arbres_data_qual = arbres_data.select_dtypes(include = ['object'])
    arbres_data_quant = arbres_data.select_dtypes(include = ['float64', 'int64'])

    encNorm(arbres_data_qual, arbres_data_quant)

    # Conservation des variables utiles

    interesting_cols_quant = ['tronc_diam', 'haut_tot', 'haut_tronc', 'fk_prec_estim', 'clc_nbr_diag', 'age_estim']
    interesting_cols_qual = ['remarquable', 'fk_stadedev']

    # Gestion des valeurs aberrantes
    
    preprocessed_data_abber = pd.concat([arbres_data_qual[interesting_cols_qual], arbres_data_quant[interesting_cols_quant]], axis = 1)

    return preprocessed_data_abber.apply(lambda col: winsorize(col, limits = [0.13, 0.13]))


# --- applyModel --------------------------------------------------------------
# Applique le GradientBoostingRegressor aux bases train/test avec prédictions de 'estim_age' et renvoie celles-ci.
# \param model (GradientBoostingRegressor), modèle de prédiction utilisé
# \return result (dict), dictionnaire contenant le nom du modèle et les prédictions associées aux bases d'apprentissage et de test

def applyModel(model):
    
    # Entraîner le modèle
    
    model.fit(X_train, y_train)

    # Faire des prédictions
    
    y_pred_train = model.predict(X_train)
    y_pred_test = model.predict(X_test)
    
    # Stocker les résultats dans un dictionnaire
    
    results = {
        'model': model,
        'y_pred_train': y_pred_train,
        'y_pred_test': y_pred_test,
    }
        
    return results


# --- modelLearning --------------------------------------------------------------
# Sépare les données en 2 bases train/test, applique le GBR et extrait la prédiction issue de la base de test. On lui appliquera l'encodage et la normalisation inverse afin de retrouver des valeurs réelles.
# \param preprocessed_data (df), les variables utiles à la regression
# \return processed_data (df), vecteur contenant les prédictions liées à la base de test


def modelLearning(preprocessed_data):

    global X_train, X_test, y_train, y_test
    
    # Séparation des donées target/features
    
    X = preprocessed_data.drop(['age_estim'], axis = 1)
    y = preprocessed_data['age_estim']
    X_train, X_test, y_train, y_test = train_test_split(X, y, train_size = 0.8, test_size = 0.2)

    # Application du modèle

    gbr_results = applyModel(model['model'])
    gbr_results['y_pred_test'] = pd.DataFrame(gbr_results['y_pred_test'], columns=['age_estim'])
    
    data_pred = pd.concat([X_test.reset_index(drop=True), gbr_results['y_pred_test']], axis=1)

    encNormInv(data_pred)
    
    return data_pred

# ----------------------------------- Main --------------------------------------------------

def main(json_file):
    # Lecture des données à partir du fichier JSON
    with open(json_file, 'r+') as f:
        data = json.load(f)

    # Conversion des données JSON en DataFrame
    arbres_data = pd.DataFrame(data)

    # Initialisation des données
    preprocessed_data = init(arbres_data)

    # Application du modèle
    processed_data = modelLearning(preprocessed_data)
    processed_data['age_predit'] = processed_data['age_estim'].apply(np.ceil)
    processed_data = processed_data.drop(['age_estim'], axis = 1)

    # Export la prédiction de l'âge en JSON
    processed_data.to_json('Besoin_client_2/data_age_predit.json', index = False)
    print('Les âges prédits ont été exportées dans le fichier age_predit.json')

# Charger les données depuis les arguments du script
parser = argparse.ArgumentParser(description="Envoi des données d'arbres de St-Quentin et prédiction d'âge de ces arbres")
parser.add_argument('json_file', type=str, help="Fichier json des arbres dont l'âge doit être prédit")
args = parser.parse_args()

main(args.json_file)








