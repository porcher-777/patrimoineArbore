# Projet de Big Data
---

## Description du jeu de données

Ce jeu de données vient du patrimoine arboré de la ville de Saint-Quentin (Aisne).
Il s'agit d'un jeu de données contenant l'ensemble des arbres de la ville de Saint-Quentin, avec leurs positions, caractéristiques (taille, diamètre, texture, ...).
Ainsi que des informations sur l'agent ayant collectés les données.

## Exploration des données

- **X**: variable quantitative, position X en RGF93-CC49 de l'arbre 
- **Y**: variable quantitative, position Y en RGF93-CC49 de l'arbre
- **OBJECTID**: variable quantitative, identifiant de l'objet dans la base de donnée
- **created_date**: variable quantitative, date de création de l'entrée dans la base de donnée
- **created_user**: variable qualitative, créateur de l'entrée dans la base de donnée
- **src_geo**: variable qualitative, source de la photo de l'arbre 
- **clc_quartier**: variable qualitative, nom de quartier de l'arbre
- **clc_secteur**: variable qualitative, nom du secteur de l'arbre
- **id_arbre**: variable quantitative, identifiant du type de l'arbre dans la base de donnée
- **haut_tot**: variable quantitative, hauteur total de l'arbre en mètres
- **haut_tronc**: variable quantitative, hauteur du tronc de l'arbre en mètres
- **tronc_diam**: variable quantitative, diamètre du tronc de l'arbre en centimètres
- **fk_arb_etat**: variable qualitative, état de présence de l'arbre
- **fk_stadedev**: variable qualitative, stade de développement de l'arbre
- **fk_port**: variable qualitative, description pour la coupe et entretien de l'arbre
- **fk_pied**: variable qualitative, composition du pied de l'arbre 
- **fk_situation**: variable qualitative, situation de l'arbre (isolé ou aligné)
- **fk_revetement**: variable qualitative, présence de revêtement sur l'arbre ou non
- **commentaire_environnement**: variable qualitative, commentaire sur l'environnement autour de l'arbre
- **dte_plantation**: variable quantitative, date de plantation de l'arbre
- **age_estim**: variable quantitative, estimation de l'âge de l'arbre
- **fk_prec_estim**: variable quantitative, précédente estimation de l'âge de l'arbre
- **clc_nbr_diag**: variable quantitative, ..
- **dte_abattage**: variable quantitative, date d'abattage de l'arbre
- **fk_nomtech**: variable qualitative, nom technique de l'arbre
- **last_edited_user**: variable qualitative, username de la dernière personne ayant effectué une modification
- **last_edited_date**: variable quantitative, date de la dernière modification
- **villeca**: variable qualitative, qui à planté l'arbre (ville ou communauté de d'aglomération de Saint-Quentin)
- **nomfrancais**: variable qualitative, nom français de la variété de l'arbre
- **nomlatin**: variable qualitative, nom latin de la variété de l'arbre
- **GlobalID**: variable qualitative, identifiant global de l'arbre
- **CreationDate**: variable quantitative, date de création de l'objet dans la base de donnée
- **Creator**: variable quantitative, username du créateur de l'objet dans la base de donnée
- **EditDate**: variable qualitative, date de modification de l'objet dans la base de donnée
- **Editor**: variable quantitative, username de la personne ayant modifié l'objet
- **feuillage**: variable quantitative, qualification du feuillage de l'arbre
- **remarquable**: variable quantitative, qualifiant si l'arbre est remarquable ou non

## Librairies utilisées

Dans ce projet nous avons utilisé divers librairies R, ci-dessous une explication des librairies et de la raison de leur utilisation.

- `leaflet`: Librairie pour réaliser des affichages de cartes interractives, utilisé pour la carte de la fonctionnalité 3.
- `leaflet legend`: Librairie pour ajouter des légendes customisés aux graphiques de leaflet, utilisé pour la légende de la carte de la fonctionnalité 3.
- `proj4`: Librairie permettant de transformer les coordonnées géographiques entre différents systèmes de référence spatiale, utilisé pour transformer les coordonnées X, Y du format RGF93-CC49 en format GPS.
- `vcd`: Librairie de visualisation et l'analyse des données catégorielles, permettant de réaliser des méthodes graphiques pour explorer et résumer des tableaux de contingence et d'autres données catégorielles. Utilisé pour visualiser des informations et réaliser le nettoyage des variables.
- `dplyr`: Librairie pour manipuler des dataframes, utiliser pour toutes les manipulations de filtrage sur le dataframe du jeu de données.
- `ggplot2`: Librairie pour réaliser des graphiques, utilisé pour la réalisation de tous les graphiques du projet.
- `ggmosaic`: Librairie pour réaliser des mosaïc graphiques, utilisé pour la fonctionnalité 4.
- `tidyverse`: Ensemble de Librairie pour utiliser pour l'analyse de données.
- `remotes`: Librairie pour installer des packages R à partir de différentes sources, utilisé pour l'installation de ggplot2 à cause d'un soucis de compatibilité.
- `plotly`: Librairie de visualisation graphique interractives, utilisé pour la visualisation de la heatmap des secteurs.
- `stats`: Librairie pour avoir des fonctionnalité d'analyse statistique. Utilisé pour réaliser des tests et de la régression linéaire.
- `stringr`: Librairie pour avoir des outils de manipulations de chaines de charactères, utilisé pour le nettoyage des données.
- `car`: Librairie pour avoir des fonctionnalité pour le diagnostic de régression et de manipulation des données.
- `DescTools`: Librairie pour avoir des fonctionnalité d'analyse descriptive des données.
- `naniar`: Librairie pour avoir des fonctionnalité de gestions des valeurs manquantes.
