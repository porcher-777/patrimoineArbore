import plotly.express as px
import pandas as pd
import json
import argparse
import joblib

# Fonction pour ajouter une colonne de prédiction dans le DataFrame
def predict_df(model, encoder, normaliser, df):
    col_pertinentes = ["latitude", "clc_secteur", "haut_tot", "haut_tronc", "tronc_diam", "age_estim", "clc_nbr_diag"]
    col_pertinentes_num = ["latitude", "haut_tot", "haut_tronc", "tronc_diam", "age_estim", "clc_nbr_diag"]
    df_to_pred = df[col_pertinentes]

    for column in df_to_pred.select_dtypes(include=['object']).columns:
        df_to_pred[column] = encoder[column].fit_transform(df_to_pred[column])
        
    df_to_pred[col_pertinentes_num] = normaliser.transform(df_to_pred[col_pertinentes_num])
    df['prediction'] = encoder["fk_arb_etat"].inverse_transform(model.predict(df_to_pred))

    return df

# Charger les données depuis les arguments du script
parser = argparse.ArgumentParser(description="Envoi des données d'arbres de St-Quentin et affichage sur une carte")
parser.add_argument('json_file', type=str, help='Fichier json des arbres à afficher sur la carte')
args = parser.parse_args()

with open(args.json_file, 'r') as file:
    # Charger les données JSON à partir du fichier
    arbre_df = pd.DataFrame(json.loads(file.read()))

# Charger le modèle pré-entrainé
model = joblib.load('Besoin_client_3/best_rf_model.pkl')

# Charger l'encodeur pré-entrainé
encoder = joblib.load('Besoin_client_3/label_encoders.pkl')

# Charger le normaliser pré-entrainé
normaliser = joblib.load('Besoin_client_3/normalizer.pkl')

df = predict_df(model, encoder, normaliser, arbre_df)

# Créer la carte interactive
fig = px.scatter_mapbox(
    df,
    lat='latitude',
    lon='longitude',
    color='prediction',
    size='tronc_diam',
    hover_name='tronc_diam',
    hover_data={'prediction': True, 'tronc_diam': True, 'haut_tot': True, 'haut_tronc': True},
    color_continuous_scale=px.colors.sequential.Viridis,
    size_max=15,
    zoom=10
)

# Mettre à jour les détails de la carte
fig.update_layout(
    mapbox_style="open-street-map",
    title="Prédictions de déracinement des arbres",
    margin={"r":0,"t":0,"l":0,"b":0}
)

# Afficher la carte
fig.show()

print(f"\n\nNombre d'arbres touchés par la tempête: {len(df[df["prediction"] == "Essouché"])}\n")
print(f"Nombre d'arbres survivants à la tempête: {len(df[df["prediction"] == "Non essouché"])}\n")