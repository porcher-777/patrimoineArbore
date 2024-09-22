# Imports nécessaires
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
import pandas as pd
import plotly.graph_objects as go
from sklearn.cluster import AgglomerativeClustering
from sklearn.metrics import silhouette_score
import matplotlib.pyplot as plt

def prepare_data(file_path):
    # Chargement des données
    donnees = pd.read_csv(file_path)

    # Sélection des colonnes pertinentes
    data = donnees[['latitude', 'longitude', 'haut_tot']]

    # Normalisation des données
    scaler = StandardScaler()
    data_scaled = scaler.fit_transform(data[['haut_tot']])

    return data, data_scaled

def k_mean(data_scaled, n_clusters):
    kmeans = KMeans(n_clusters=n_clusters, random_state=42)
    clusters = kmeans.fit_predict(data_scaled)
    return clusters

def agglomerative_clustering(data_scaled , n_clusters):
    clustering = AgglomerativeClustering(n_clusters, linkage='ward')
    clusters = clustering.fit_predict(data_scaled)
    return clusters

def add_cluster_labels(data, clusters, labels):
    data['Cluster'] = clusters
    data['Cluster Label'] = data['Cluster'].apply(lambda x: labels[x])
    return data

##########################################################################
########################### Les appels ###################################
##########################################################################

file_path = 'Besoin_client_1/Data_Arbre.csv'

# Demander à l'utilisateur le nombre de clusters
n_clusters = int(input("Entrez le nombre de clusters souhaité (nombre supérieur à 0, plus il est grand plus le programme sera lent): "))

# Préparation des données
data, data_scaled = prepare_data(file_path)

# Calcul des clusters pour l'entrée utilisateur avec KMeans et Agglomerative Clustering
clusters_kmeans_user = k_mean(data_scaled, n_clusters)
clusters_agglom_user = agglomerative_clustering(data_scaled, n_clusters)

# Calcul des clusters pour 2 et 3 clusters avec KMeans
clusters_kmeans_2 = k_mean(data_scaled, 2)
clusters_kmeans_3 = k_mean(data_scaled, 3)

# Calcul des clusters pour 2 et 3 clusters avec Agglomerative Clustering
clusters_agglom_2 = agglomerative_clustering(data_scaled, 2)
clusters_agglom_3 = agglomerative_clustering(data_scaled, 3)

# Génération des étiquettes pour le nombre de clusters choisi par l'utilisateur
labels_user = ['Cluster ' + str(i) for i in range(n_clusters)]

# Ajout des étiquettes de clusters
labels_2 = ['Petit', 'Grand']
labels_3 = ['Petit', 'Moyen', 'Grand']

data_kmeans_2 = add_cluster_labels(data.copy(), clusters_kmeans_2, labels_2)
data_kmeans_3 = add_cluster_labels(data.copy(), clusters_kmeans_3, labels_3)
data_agglom_2 = add_cluster_labels(data.copy(), clusters_agglom_2, labels_2)
data_agglom_3 = add_cluster_labels(data.copy(), clusters_agglom_3, labels_3)
data_kmeans_user = add_cluster_labels(data.copy(), clusters_kmeans_user, labels_user)
data_agglom_user = add_cluster_labels(data.copy(), clusters_agglom_user, labels_user)

# Création initiale de la figure avec les clusters choisis par l'utilisateur en KMeans
fig = go.Figure()

# Add scatter traces
fig.add_trace(go.Scattermapbox(
    lat=data_kmeans_user['latitude'],
    lon=data_kmeans_user['longitude'],
    mode='markers',
    marker=dict(
        size=8,
        color=data_kmeans_user['Cluster'],
        colorscale='Viridis',
        opacity=0.8,
        showscale=True,
        colorbar=dict(
            title="Cluster",
            tickvals=list(range(n_clusters)),
            ticktext=labels_user
        )
    ),
    text=data_kmeans_user['Cluster Label'],
    hoverinfo='text',
    name=f'KMeans {n_clusters} Clusters'
))

fig.add_trace(go.Scattermapbox(
    lat=data_kmeans_2['latitude'],
    lon=data_kmeans_2['longitude'],
    mode='markers',
    marker=dict(
        size=8,
        color=data_kmeans_2['Cluster'],
        colorscale='Viridis',
        opacity=0.8,
        showscale=True,
        colorbar=dict(
            title="Cluster",
            tickvals=[0, 1],
            ticktext=labels_2
        )
    ),
    text=data_kmeans_2['Cluster Label'],
    hoverinfo='text',
    name='KMeans 2 Clusters',
    visible=False
))

fig.add_trace(go.Scattermapbox(
    lat=data_kmeans_3['latitude'],
    lon=data_kmeans_3['longitude'],
    mode='markers',
    marker=dict(
        size=8,
        color=data_kmeans_3['Cluster'],
        colorscale='Viridis',
        opacity=0.8,
        showscale=True,
        colorbar=dict(
            title="Cluster",
            tickvals=[0, 1, 2],
            ticktext=labels_3
        )
    ),
    text=data_kmeans_3['Cluster Label'],
    hoverinfo='text',
    name='KMeans 3 Clusters',
    visible=False
))

fig.add_trace(go.Scattermapbox(
    lat=data_agglom_2['latitude'],
    lon=data_agglom_2['longitude'],
    mode='markers',
    marker=dict(
        size=8,
        color=data_agglom_2['Cluster'],
        colorscale='Viridis',
        opacity=0.8,
        showscale=True,
        colorbar=dict(
            title="Cluster",
            tickvals=[0, 1],
            ticktext=labels_2
        )
    ),
    text=data_agglom_2['Cluster Label'],
    hoverinfo='text',
    name='Agglomerative 2 Clusters',
    visible=False
))

fig.add_trace(go.Scattermapbox(
    lat=data_agglom_3['latitude'],
    lon=data_agglom_3['longitude'],
    mode='markers',
    marker=dict(
        size=8,
        color=data_agglom_3['Cluster'],
        colorscale='Viridis',
        opacity=0.8,
        showscale=True,
        colorbar=dict(
            title="Cluster",
            tickvals=[0, 1, 2],
            ticktext=labels_3
        )
    ),
    text=data_agglom_3['Cluster Label'],
    hoverinfo='text',
    name='Agglomerative 3 Clusters',
    visible=False
))

fig.add_trace(go.Scattermapbox(
    lat=data_agglom_user['latitude'],
    lon=data_agglom_user['longitude'],
    mode='markers',
    marker=dict(
        size=8,
        color=data_agglom_user['Cluster'],
        colorscale='Viridis',
        opacity=0.8,
        showscale=True,
        colorbar=dict(
            title="Cluster",
            tickvals=list(range(n_clusters)),
            ticktext=labels_user
        )
    ),
    text=data_agglom_user['Cluster Label'],
    hoverinfo='text',
    name=f'Agglomerative {n_clusters} Clusters',
    visible=False
))

# Initial layout setup
fig.update_layout(
    autosize=True,
    hovermode='closest',
    mapbox=dict(
        style='carto-positron',
        bearing=0,
        center=dict(
            lat=49.84889,
            lon=3.28757
        ),
        pitch=0,
        zoom=13
    ),
    updatemenus=[
        dict(
            buttons=list([
                dict(
                    args=[{"visible": [True, False, False, False, False, False]}],
                    label=f"KMeans {n_clusters} clusters",
                    method="update"
                ),
                dict(
                    args=[{"visible": [False, True, False, False, False, False]}],
                    label="KMeans 2 clusters",
                    method="update"
                ),
                dict(
                    args=[{"visible": [False, False, True, False, False, False]}],
                    label="KMeans 3 clusters",
                    method="update"
                ),
                dict(
                    args=[{"visible": [False, False, False, True, False, False]}],
                    label="Agglomerative 2 clusters",
                    method="update"
                ),
                dict(
                    args=[{"visible": [False, False, False, False, True, False]}],
                    label="Agglomerative 3 clusters",
                    method="update"
                ),
                dict(
                    args=[{"visible": [False, False, False, False, False, True]}],
                    label=f"Agglomerative {n_clusters} clusters",
                    method="update"
                )
            ]),
            type="buttons",
            direction="right",
            pad={"r": 10, "t": 10},
            showactive=True,
            x=0.1,
            xanchor="left",
            y=1.1,
            yanchor="top"
        )
    ],
    annotations=[
        dict(text="Nombre de clusters:", showarrow=False,
             x=0, y=1.15, yref="paper", align="left")
    ]
)

fig.show()
