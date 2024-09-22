# Import des données nettoyées
if(!exists('clean_data_R')) source("clean-data.R")

# --- Visualisation des données sur la carte ---

# Installer des librairies si nécessaire
if (!require("leaflet")) install.packages("leaflet")
if (!require("leaflegend")) install.packages("leaflegend")
if (!require("proj4")) install.packages("proj4")

# Import des libraries nécessaires
library(leaflet) # Affichage de la carte
library(leaflegend) # Légendes sur la carte
library(proj4) # Conversion des coordonnées en longitude, latitude

# Définir les projections
proj_rgf93_cc49 <- "+proj=lcc +lat_1=48.25 +lat_2=49.75 +lat_0=49 +lon_0=3 +x_0=1700000 +y_0=8200000 +ellps=GRS80 +towgs84=0,0,0 +units=m +no_defs"

# Conversion des coordonnés du système RGF93-CC49
coords_wgs84 <- project(as.matrix(patrimoine_w[, c("X", "Y")]), proj = proj_rgf93_cc49, inverse = TRUE)

# Icônes d'arbre
treeIcon = makeIcon(
  iconUrl = "https://cdn-icons-png.flaticon.com/512/490/490091.png",
  iconWidth = 50,
  iconHeight = 50
)

# Compter le nombre d'arbres par quartier/secteur
tree_counts <- patrimoine_w %>%
  group_by(clc_quartier) %>%
  summarize(n_trees = n(), .groups = 'drop')

# Ajout des coordonnées dans le dataframe
colnames(coords_wgs84)[(ncol(coords_wgs84)-1):ncol(coords_wgs84)] <- c("lng", "lat")
patrimoine_w <- cbind(patrimoine_w, coords_wgs84)

# Filtrer pour obtenir le premier arbre de chaque quartier
first_tree_each_quartier <- patrimoine_w %>%
  group_by(clc_quartier) %>%
  slice(1) %>%
  ungroup()

# Légende du nombre d'arbre par quartier
html_legend <- "<img src='https://cdn-icons-png.flaticon.com/512/490/490091.png' width=20 height=20>Nombre d'arbre dans le quartier<br/>"

# Affichage de la carte
leaflet() %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Carte Esri") %>%
  addTiles() %>%
  setView(
    lng = 3.28757,
    lat = 49.84889,
    zoom = 12
  ) %>%
  addLayersControl(
    baseGroups = c("Carte StreetMap", "Carte Esri"),
    overlayGroups = c("Arbres"),
    position = "topright"
  ) %>%
  addCircles(
    data = na.omit(data.frame(lng = coords_wgs84[,1], lat = coords_wgs84[,2])), 
    radius = 2.5,
    color = ifelse(patrimoine_w$remarquable == "oui", "yellow", "darkslategray"),
    group = "Arbres", 
    popup = paste(
               "Hauteur totale", patrimoine_w$haut_tot, "m<br>",
               "Hauteur du tronc:", patrimoine_w$haut_tronc, "m<br>",
               "Diamètre du tronc:", patrimoine_w$tronc_diam, "cm<br>",
               "Âge estimée:", patrimoine_w$age_estim, "ans<br>",
               "Stade de développement de l'arbre:", patrimoine_w$fk_stadedev, "<br>")
  ) %>%
  addMarkers(
    data = na.omit(first_tree_each_quartier),
    icon = treeIcon,
    popup = paste("Quartier: ", first_tree_each_quartier$clc_quartier, "<br>Nombre d'arbres: ", tree_counts$n_trees[match(first_tree_each_quartier$clc_quartier, tree_counts$clc_quartier)])
  ) %>%
  addLegend(
    "bottomright",
    colors = c("darkslategray", "yellow"),
    labels = c("Arbre non remarquable", "Arbre remarquable"),
    title = "Légende",
    opacity = 1
  ) %>%
  addControl(html = html_legend, position = "bottomleft")