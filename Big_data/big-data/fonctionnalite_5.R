# Import des données nettoyées
if(!exists('clean_data_R')) source("clean-data.R")

# Régression linéaire pour prédire l'âge de l'arbre
age_model <- lm(age_estim ~ clc_quartier + clc_secteur + fk_stadedev + fk_port + fk_pied + fk_situation + haut_tronc + OBJECTID + haut_tot + tronc_diam, data = patrimoine_w)
summary(age_model)

# Ajouter les prédictions au dataset
patrimoine_w$predicted_age <- predict(age_model, patrimoine_w)

# Visualiser les résultats de la régression
# Regression de l'âge estimé sur la hauteur totale
ggplot(patrimoine_w, aes(x = haut_tot, y = age_estim)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Régression de l'âge estimé sur la hauteur totale",
       x = "Hauteur totale (m)",
       y = "Âge estimé (années)") +
  theme_minimal()

# Regression de l'âge estimé sur le diamètre du tronc
ggplot(patrimoine_w, aes(x = tronc_diam, y = age_estim)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Régression de l'âge estimé sur le diamètre du tronc",
       x = "Diamètre du tronc (cm)",
       y = "Âge estimé (années)") +
  theme_minimal()


# Régression logistique pour déterminer les arbres à abattre
patrimoine_w$abattu <- ifelse(patrimoine_w$fk_arb_etat == "abattu", 1, 0)

# Convertir les colonnes pertinentes en numérique (s'assurer que les colonnes haut_tot et haut_tronc sont bien numériques)
patrimoine_w$haut_tot <- as.numeric(gsub(",", ".", patrimoine_w$haut_tot))
patrimoine_w$haut_tronc <- as.numeric(gsub(",", ".", patrimoine_w$haut_tronc))

# Régression logistique avec les données filtrées
logistic_model <- glm(abattu ~  haut_tronc + tronc_diam + fk_stadedev, family ="binomial", data = patrimoine_w)
summary(logistic_model)

# Visualiser les probabilités prédites par le modèle logistique
patrimoine_w$predicted_prob <- predict(logistic_model, type = "response")

# Ajouter l'index pour aligner avec data
patrimoine_w$index <- rownames(patrimoine_w)

# Suppression des probabilités pour les arbres déjà abattus
patrimoine_w$predicted_prob[patrimoine_w$abattu == 1] <- NA

# Filtrer les probabilités prédites non nulles
patrimoine_w <- patrimoine_w[!is.na(patrimoine_w$predicted_prob), ]

ggplot(patrimoine_w, aes(x = predicted_prob)) +
  geom_histogram(binwidth = 0.1, position = "dodge") +
  labs(title = "Probabilités prévues de l'abattage d'arbres",
       x = "Probabilité prédite",
       y = "Nombre d'arbres",
       fill = "Abattre") +
  theme_minimal()

# Visualiser les probabilités prédites en fonction de l'âge estimé
ggplot(patrimoine_w, aes(x = age_estim, y = predicted_prob)) +
  geom_point() +
  geom_smooth(method = "glm") +
  labs(title = "Probabilités d'abattage en fonction de l'âge estimé",
       x = "Âge estimé (années)",
       y = "Probabilité d'abattage") +
  theme_minimal() +
  theme(text = element_text(size = 8))

