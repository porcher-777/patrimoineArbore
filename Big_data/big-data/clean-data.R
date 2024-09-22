if(!exists('clean_data_R')){
  clean_data_R <- TRUE
  
  # Installation des libraries nécessaires
  if (!require("stats")) install.packages("stats")
  if (!require("ggplot2")) install.packages("ggplot2")
  if (!require("stringr")) install.packages("stringr")
  if (!require("car")) install.packages("car")
  if (!require("DescTools")) install.packages("DescTools")
  if (!require("dplyr")) install.packages("dplyr")
  if (!require("tidyr")) install.packages("tidyr")
  if (!require("naniar")) install.packages("naniar")
  
  # Importation des librairies nécessaires
  
  library(stats)
  library(ggplot2)
  library(stringr)
  library(car)
  library(DescTools)
  library(dplyr)
  library(tidyr)
  library(naniar)
  
  # Lecture du fichier csv
  
  patrimoine <- read.csv("Assets/Patrimoine_Arbore.csv", header = TRUE, sep = ",", quote = "\"", dec = ".",)
  #head(patrimoine, n=10L)
  
  # Nettoyage des colonnes inutiles et séparation entre variables quantitatives et qualitatives
  
  patrimoine_w <- subset( patrimoine, select = -c(created_date, created_user, commentaire_environnement, 
                                                  dte_abattage, fk_nomtech, fk_nomtech, last_edited_date, 
                                                  nomfrancais, nomlatin, GlobalID, CreationDate, Creator, 
                                                  EditDate, Editor, last_edited_user, dte_plantation, 
                                                  clc_nbr_diag, fk_revetement, fk_prec_estim ))
  #head(patrimoine_w, n=10L)
  
  

  # Analyse des données pour déterminer la stratégie de nettoyage
    str(patrimoine_w) # Première analyse
  summary(patrimoine_w) # Résumé des valeurs manquantes
  #vis_miss(patrimoine_w) # Visualiser les données manquantes
  #gg_miss_upset(patrimoine_w) # Visualiser corrélation entre NA
  
  
  
  # Nettoyage
  patrimoine_w[patrimoine_w == ""] <- NA # # Remplacer les valeurs manquantes par NA
  patrimoine_w <- distinct(patrimoine_w) # Suppression des doublons
  
  patrimoine_w <- patrimoine_w %>% 
    mutate(across(where(is.character), ~ str_to_lower(str_trim(.)))) %>% # Convertir toutes les colonnes de type texte en minuscules et supprimer les espaces inutiles
    mutate(across(everything(), ~str_replace_all(., " ", "_"))) %>% # Remplacer les espaces par des underscore dans chaque colonne "chr"
    mutate_at(c("OBJECTID", "tronc_diam", "age_estim", "haut_tot", "haut_tronc", "X", "Y"), as.numeric) %>%
    mutate(across(where(is.numeric), ~replace_na(., median(., na.rm = TRUE)))) %>% # Remplacer les valeurs manquantes par la médiane des colonnes
    filter(haut_tronc <= haut_tot)
  
  replace_na(patrimoine_w[['age_estim']], 0)
  
  # 11% de pertes en enlevant les lignes avec 1 ou plus valeurs manquantes => on peut les imputer
  
  #dev.off()
  
  na_counts <- sum(rowSums(is.na(patrimoine_w)) >= 1)
  na_counts
  
  patrimoine_w <- patrimoine_w[rowSums(is.na(patrimoine_w)) < 1, ]
  
  
  # Traitement des valeurs aberrantes
  num_cols <- c("haut_tot", "haut_tronc", "tronc_diam", "age_estim")
  par(mfrow = c(2, 4))
  
  for (col in num_cols) {
    patrimoine_w[[col]] <- as.numeric(patrimoine_w[[col]])  # Convertir la colonne en numérique
    boxplot(patrimoine_w[[col]], main = paste("Diagramme en boîte de", col), ylab = col, col = "green")
    
    # On utilise la Winsorisation afin de réduire l'impact des valeurs aberrantes
    Q1 <- quantile(patrimoine_w[[col]], 0.25, na.rm = TRUE)
    Q3 <- quantile(patrimoine_w[[col]], 0.75, na.rm = TRUE)
    IQR <- IQR(patrimoine_w[[col]], na.rm = TRUE)
    
    # Calculer les bornes inférieure et supérieure
    borne_inf <- Q1 - 1.5 * IQR
    borne_sup <- Q3 + 1.5 * IQR
    
    # Appliquer la Winsorisation
    patrimoine_w[[col]] <- pmin(pmax(patrimoine_w[[col]], borne_inf), borne_sup)
    
    boxplot(patrimoine_w[[col]], main = paste("Diagramme en boîte de", col), ylab = col, col = "red")
    
  }
  
  #vis_miss(patrimoine_w)
  summary(patrimoine_w)
  
  # Exportation du tableau de données pour le big data
  write.csv(patrimoine_w, "Assets/ia_data.csv", row.names = FALSE)
}