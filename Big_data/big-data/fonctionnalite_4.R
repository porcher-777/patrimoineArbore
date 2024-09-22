# Import des données nettoyées
if(!exists('clean_data_R')) source("clean-data.R")
 
  if (!require("vcd")) install.packages("vcd")
  if (!require("dplyr")) install.packages("dplyr")
  if (!require("ggplot2")) install.packages("ggplot2")
  if (!require("ggmosaic")) install.packages("ggmosaic")
  if (!require("tidyverse")) install.packages("tidyverse")
  if (!require("remotes")) install.packages("remotes")
  if (!require("plotly")) install.packages("plotly")

  library(vcd)
  library(dplyr)
  library(ggplot2)
  library(ggmosaic)
  library(tidyverse)
  
  # Utilisation d'une version antérieure de ggplot2 par soucis de compatibilité
  
  library(remotes)
  remotes::install_version("ggplot2", version = "3.3.3", repos = "http://cran.us.r-project.org")
  
  library(plotly)
  
  
  # ---------------------Analyse des corrélations-----------------------------------------------
  
  # Définir les colonnes quantitatives et qualitatives
  
  
  patrimoine_quantitative <- subset(patrimoine_w, select = -c(src_geo, clc_quartier, clc_secteur, fk_arb_etat, fk_stadedev, fk_port, fk_pied, fk_situation, villeca, feuillage, remarquable))
  patrimoine_qualitative <- subset(patrimoine_w, select = -c(X, Y, OBJECTID, id_arbre, haut_tot, haut_tronc, tronc_diam, age_estim))
  
  # Analyse des corrélations entre chaque colonne
  
  patrimoine_quantitative <- c("X", "Y", "OBJECTID", "id_arbre", "haut_tot", "haut_tronc", "tronc_diam", "age_estim") #subset(patrimoine_w, select = -c(src_geo, clc_quartier, clc_secteur, fk_arb_etat, fk_stadedev, fk_port, fk_pied, fk_situation, villeca, feuillage, remarquable))
  patrimoine_qualitative_bin <- c("villeca", "feuillage", "remarquable") # subset(patrimoine_w, select = -c(X, Y, OBJECTID, id_arbre, haut_tot, haut_tronc, tronc_diam, age_estim, src_geo, clc_quartier, clc_secteur, fk_arb_etat, fk_stadedev, fk_port, fk_pied, fk_situation))
  patrimoine_qualitative_poly <- c("src_geo", "clc_quartier", "clc_secteur", "fk_arb_etat", "fk_stadedev", "fk_port", "fk_pied", "fk_situation") # subset(patrimoine_w, select = -c(X, Y, OBJECTID, id_arbre, haut_tot, haut_tronc, tronc_diam, age_estim, villeca, feuillage, remarquable))
  
  
  # Fonction pour calculer le rapport de corrélation (η²)
  
  calculate_eta_squared <- function(df, qualitative_var, quantitative_var) {
    formula <- as.formula(paste(quantitative_var, "~", qualitative_var))
    anova_result <- aov(formula, data = df)
    ss_total <- sum(anova_result$residuals^2) + sum((anova_result$fitted.values - mean(anova_result$fitted.values))^2)
    ss_between <- sum((anova_result$fitted.values - mean(anova_result$fitted.values))^2)
    eta_squared <- ss_between / ss_total
    return(eta_squared)
  }
  
  
  # Fonction pour calculer la corrélation de Pearson
  
  calculate_pearson_correlation <- function(df, var1, var2) {
    if (!is.numeric(df[[var1]]) || !is.numeric(df[[var2]])) {
      return(NA)
    }
    cor(df[[var1]], df[[var2]], use = "complete.obs")
  }
  
  
  # Fonction pour calculer le V de Cramer
  
  calculate_cramers_v <- function(df, var1, var2) {
    tbl <- table(df[[var1]], df[[var2]])
    chi_sq <- chisq.test(tbl)$statistic
    n <- sum(tbl)
    min_dim <- min(dim(tbl))
    cramer_v <- sqrt(chi_sq / (n * (min_dim - 1)))
    return(cramer_v)
  }
  
  # Initialiser une matrice pour stocker les résultats des corrélations
  
  all_columns <- colnames(patrimoine_w)
  correlation_matrix <- matrix(NA, nrow = length(all_columns), ncol = length(all_columns), dimnames = list(all_columns, all_columns))
  
  # Calculer les corrélations
  
  for (i in seq_along(all_columns)) {
    for (j in seq_along(all_columns)) {
      var1 <- all_columns[i]
      var2 <- all_columns[j]
      
      # Calculer la corrélation en fonction du type de variable
      if (var1 %in% names(patrimoine_quantitative) && var2 %in% names(patrimoine_quantitative)) {
        correlation_matrix[i, j] <- calculate_pearson_correlation(patrimoine_w, var1, var2)
      } else if (var1 %in% names(patrimoine_qualitative) && var2 %in% names(patrimoine_quantitative)) {
        correlation_matrix[i, j] <- calculate_eta_squared(patrimoine_w, var1, var2)
      } else if (var1 %in% names(patrimoine_quantitative) && var2 %in% names(patrimoine_qualitative)) {
        correlation_matrix[i, j] <- calculate_eta_squared(patrimoine_w, var2, var1)
      } else if (var1 %in% names(patrimoine_qualitative) && var2 %in% names(patrimoine_qualitative)) {
        correlation_matrix[i, j] <- calculate_cramers_v(patrimoine_w, var1, var2)
      }
    }
  }
  
  
  # Sélectionner les colonnes quantitatives pour l'analyse bivariée
  
  columns_of_interest <- c("X", "Y", "OBJECTID", "id_arbre", "haut_tot", "haut_tronc", "tronc_diam", "age_estim")
  data_filtered <- patrimoine_w[columns_of_interest]
  data_filtered <- Filter(is.numeric, data_filtered)
  
  
  
  # Calcul des corrélations pour les variables quantitatives
  
  correlation_matrix_num <- cor(data_filtered, use = "complete.obs")
  
  # Trouver les paires de variables avec une corrélation absolue supérieure à 0.4
  
  high_correlation_pairs <- which(abs(correlation_matrix_num) > 0.4, arr.ind = TRUE)
  high_correlation_pairs <- high_correlation_pairs[high_correlation_pairs[,1] != high_correlation_pairs[,2], ]
  unique_pairs <- high_correlation_pairs[high_correlation_pairs[,1] < high_correlation_pairs[,2], ]
  
  
  
  # Analyses bivariées pour les variables quantitatives corrélées
  
  print(eta_squared_matrix) # Rapport de corrélation
  
  par(mfrow = c(1, 1))
  corrplot(eta_squared_matrix, method = "circle", type = "lower", tl.col = "black", tl.srt = 45)
  
  
  # Trouver les paires de variables avec une corrélation absolue supérieure à 0.4
  
  high_correlation_pairs <- which(abs(eta_squared_matrix) > 0.4, arr.ind = TRUE)
  high_correlation_pairs <- high_correlation_pairs[high_correlation_pairs[,1] != high_correlation_pairs[,2], ]
  
  # Filtrer les paires uniques
  unique_pairs <- high_correlation_pairs[high_correlation_pairs[,1] < high_correlation_pairs[,2], ]
  
  # Analyses bivariées
  par(mfrow = c(2, 2))
  
  for (i in 1:nrow(unique_pairs)) {
    var1 <- colnames(data_filtered)[unique_pairs[i, 1]]
    var2 <- colnames(data_filtered)[unique_pairs[i, 2]]
    
    cat("\n\n### Analyse bivariée entre", var1, "et", var2, "###\n\n")
    
    # Résumé statistique
    summary_stats <- summary(data_filtered[, c(var1, var2)])
    print(summary_stats)
    
    # Scatter plot
    plot <- ggplot(data_filtered, aes_string(x = var1, y = var2)) +
      geom_point() +
      labs(title = paste("Scatter plot de", var1, "et", var2),
           x = var1,
           y = var2) +
      theme_minimal()
    print(plot)
  }
  
  # ------------------------------- Visualisation des corrélations ------------------------------------
  
  # ------------------------------- Secteur / Quartier ------------------------------------------------
  
  
  # Tableau de contingence
  
  quartier_secteur <- table(patrimoine_w$clc_quartier, patrimoine_w$clc_secteur)
  quartier_secteur_df <- as.data.frame(as.table(quartier_secteur))
  colnames(quartier_secteur_df) <- c("Quartier", "Secteur", "Freq")
  
  # Fréquence par quartier
  
  quartier_total_freq <- quartier_secteur_df %>%
    group_by(Quartier) %>%
    summarise(Total_Freq = sum(Freq)) %>%
    arrange(Total_Freq)
  
  quartier_secteur_df <- quartier_secteur_df %>%
    filter(Freq > 0)
  
  # On utilisera une heatMap interactive en raison du nombre de secteur très important
  
  plot_ly(quartier_secteur_df, x = ~Quartier, y = ~Secteur, z = ~Freq, type = "heatmap", colors = colorRamp(c("white", "red")))
  
  # ------------------------------- Ville / Quartier ------------------------------------------------
  
  villeca_quartier <- table(patrimoine_w$villeca, patrimoine_w$clc_quartier)
  villeca_quartier_df <- as.data.frame(as.table(villeca_quartier))
  colnames(villeca_quartier_df) <- c("Ville", "Quartier", "Freq")
  
  # Créer un graphique avec ggmosaic
  
  ggplot(villeca_quartier_df) +
    geom_mosaic(aes(weight = Freq, x = product(Quartier, Ville), fill = Quartier)) +
    labs(title = "Visualisation de la proportion d'arbres plantés par la ville et l'agglomération par quartier", x = "Ville_ca", y = "Quartier", fill = "Quartiers") +
    facet_grid(~Ville) +
    theme(aspect.ratio = 1,
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank()) 
  
  # ------------------------------- Remarquable / Stade_dev ------------------------------------------------
  
  
  remarquable_stadedev <- table(patrimoine_w$remarquable, patrimoine_w$fk_stadedev)
  remarquable_stadedev_df <- as.data.frame(as.table(remarquable_stadedev))
  colnames(remarquable_stadedev_df) <- c("Remarquable", "Stade_de_dev", "Freq")
  
  
  ggplot(remarquable_stadedev_df) +
    geom_mosaic(aes(weight = Freq, x = product(Stade_de_dev, Remarquable), fill = Stade_de_dev)) +
    labs(title = "Visualisation de la proportion d'arbres remarquables par rapport à leur stade de développement", x = "Remarquable", y = "Stade de développement", fill = "Stades de développement") +
    facet_grid(~Remarquable) +
    theme(aspect.ratio = 1,
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank()) 
  
  # ------------------------------- Stade_de_dev / Quartier ------------------------------------------------
  
  stadedev_quartier <- table(patrimoine_w$fk_stadedev, patrimoine_w$clc_quartier)
  stadedev_quartier_df <- as.data.frame(as.table(stadedev_quartier)) %>% filter(Freq > 0)
  colnames(stadedev_quartier_df) <- c("Stade_de_dev", "Quartier", "Freq")
  
  
  ggplot(stadedev_quartier_df) +
    geom_mosaic(aes(weight = Freq, 
                    x = product(Quartier, Stade_de_dev), 
                    fill = Quartier)) +
    labs(title = "Visualisation du stade de développement des arbres par quartier", x = "Stade de développement", y = "Quartier", fill = "Quartiers") +
    facet_grid(~Stade_de_dev) +
    theme(aspect.ratio = 3,
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank()) 
  
  # ------------------------------- Ville / Secteur ------------------------------------------------
  
  # Tableau de contingence
  
  ville_secteur <- table(patrimoine_w$villeca, patrimoine_w$clc_secteur)
  ville_secteur_df <- as.data.frame(as.table(ville_secteur))
  colnames(ville_secteur_df) <- c("Ville", "Secteur", "Freq")
  
  # Fréquence par Ville
  
  ville_total_freq <- ville_secteur_df %>%
    group_by(Ville) %>%
    summarise(Total_Freq = sum(Freq)) %>%
    arrange(Total_Freq)
  
  ville_secteur_df <- ville_secteur_df %>%
    filter(Freq > 0)
  
  # On utilisera une heatMap interactive en raison du nombre de secteur très important
  
  plot_ly(ville_secteur_df, x = ~Ville, y = ~Secteur, z = ~Freq, type = "heatmap", colors = colorRamp(c("white", "red")))
  
  

# ------------------------------- Test du khi2 ------------------------------------------------


# Assurer que les colonnes sont des facteurs pour le test du khi-deux
data_factors <- patrimoine_w %>%
  mutate(across(where(is.character), as.factor)) %>%
  mutate(across(where(is.factor), as.factor))

# Obtenir les noms des colonnes catégorielles
categorical_columns <- names(data_factors)[sapply(data_factors, is.factor)]

# Créer une matrice vide pour stocker les p-values
p_values_matrix <- matrix(NA, ncol = length(categorical_columns), nrow = length(categorical_columns),
                          dimnames = list(categorical_columns, categorical_columns))

# Effectuer le test du khi-deux pour chaque paire de variables catégorielles
for (i in 1:length(categorical_columns)) {
  for (j in 1:length(categorical_columns)) {
    if (i != j) {
      tbl <- table(data_factors[[categorical_columns[i]]], data_factors[[categorical_columns[j]]])
      chi2_test <- chisq.test(tbl)
      p_values_matrix[i, j] <- chi2_test$p.value
    }
  }
}

# Convertir la matrice en data frame pour ggplot
p_values_df <- as.data.frame(as.table(p_values_matrix))

# Créer une heatmap pour visualiser les p-values
ggplot(p_values_df, aes(x = Var1, y = Var2, fill = Freq)) +
  geom_tile() +
  scale_fill_gradient(low = "blue", high = "red", na.value = "white") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Heatmap des p-values des tests du khi-deux entre variables catégorielles",
       x = "Variable X",
       y = "Variable Y",
       fill = "p-value")

# Afficher les p-values significatives
significant_pairs <- p_values_df %>%
  filter(Freq < 0.05) %>%
  arrange(Freq)

print("Paires de variables avec p-value < 0.05 :")
print(significant_pairs)

