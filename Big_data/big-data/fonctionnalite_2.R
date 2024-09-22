# Import des données nettoyées
if(!exists('clean_data_R')) source("clean-data.R")

print(patrimoine_w)

# Histogramme de la répartition des arbres suivant leur stade de développement
ggplot(patrimoine_w, aes(x = factor(fk_stadedev), fill = factor(fk_stadedev))) +
  geom_bar(stat = "count") +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Répartition des arbres suivant leur stade de développement",
       x = "Stade de développement",
       y = "Nombre d'arbres",
       fill = "Stade de développement") +
  stat_count(binwidth = 1, 
             geom = 'text', 
             color = 'black', 
             aes(label = ..count..),
             position = position_stack(vjust = 0.5)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Histogramme de la répartition des arbres en fonction de leur quartier
ggplot(patrimoine_w, aes(x = factor(clc_quartier), fill = factor(clc_quartier))) +
  geom_bar(stat = "count") +
  stat_count(binwidth = 1, 
             geom = 'text', 
             color = 'black', 
             aes(label = ..count..),
             position = position_stack(vjust = 0.5)) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Répartition des arbres suivant leur quartier",
       x = "Nom du quartier",
       y = "Nombre d'arbres",
       fill = "Nom du quartier") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Histogramme de la répartition des arbres en fonction de leur situation
ggplot(patrimoine_w, aes(x = factor(fk_situation), fill = factor(fk_situation))) +
  geom_bar(stat = "count") +
  stat_count(binwidth = 1, 
             geom = 'text', 
             color = 'black', 
             aes(label = ..count..),
             position = position_stack(vjust = 0.5)) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Répartition des arbres suivant leur situation",
       x = "Situation de l'arbre",
       y = "Nombre d'arbres",
       fill = "Situation de l'arbre") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Histogramme de la répartition des arbres en fonction de leur hauteur de tronc
ggplot(patrimoine_w, aes(x = factor(haut_tronc), fill = factor(haut_tronc))) +
  geom_bar(stat = "count") +
  stat_count(binwidth = 1, 
             geom = 'text', 
             color = 'black', 
             aes(label = ..count..),
             position = position_stack(vjust = 0.5)) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Répartition des arbres suivant leur hauteur de tronc",
       x = "Hauteur du tronc de l'arbre (m)",
       y = "Nombre d'arbres",
       fill = "Hauteur du tronc (m)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Histogramme de la répartition des arbres en fonction de leur taille totale
ggplot(patrimoine_w, aes(x = factor(haut_tot), fill = factor(haut_tot))) +
  geom_bar(stat = "count") +
  stat_count(binwidth = 1, 
             geom = 'text', 
             color = 'black', 
             aes(label = ..count..),
             position = position_stack(vjust = 0.5)) +
  labs(title = "Répartition des arbres suivant l'hauteur totale de l'arbre",
       x = "Hauteur totale de l'arbre (m)",
       y = "Nombre d'arbres",
       fill = "Hauteur totale (m)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Histogramme de la répartition des arbres en fonction de leur feuillage
ggplot(patrimoine_w, aes(x = factor(feuillage), fill = factor(feuillage))) +
  geom_bar(stat = "count") +
  stat_count(binwidth = 1, 
             geom = 'text', 
             color = 'black', 
             aes(label = ..count..),
             position = position_stack(vjust = 0.5)) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Répartition des arbres suivant leur feuillage",
       x = "Feuillage de l'arbre",
       y = "Nombre d'arbres",
       fill = "Type de feuillage de l'arbre") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Histogramme de la répartition des arbres en fonction de leur remarquabilité
ggplot(patrimoine_w, aes(x = factor(remarquable), fill = factor(remarquable))) +
  geom_bar(stat = "count") +
  stat_count(binwidth = 1, 
             geom = 'text', 
             color = 'black', 
             aes(label = ..count..),
             position = position_stack(vjust = 0.5)) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Répartition des arbres suivant leur remarquabilité",
       x = "Remarquabilité de l'arbre",
       y = "Nombre d'arbres",
       fill = "Arbre remarquable ?") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Histogramme de la répartition des arbres en fonction de leur état
ggplot(patrimoine_w, aes(x = factor(fk_arb_etat), fill = factor(fk_arb_etat))) +
  geom_bar(stat = "count") +
  stat_count(binwidth = 1, 
             geom = 'text', 
             color = 'black', 
             aes(label = ..count..),
             position = position_stack(vjust = 0.5)) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Répartition des arbres suivant leur état",
       x = "État de l'arbre",
       y = "Nombre d'arbres",
       fill = "État de l'arbre") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Histogramme de la répartition des arbres en fonction de l'entité ayant planté les arbres
ggplot(patrimoine_w, aes(x = factor(villeca), fill = factor(villeca))) +
  geom_bar(stat = "count") +
  stat_count(binwidth = 1, 
             geom = 'text', 
             color = 'black', 
             aes(label = ..count..),
             position = position_stack(vjust = 0.5)) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Répartition des arbres suivant l'entité l'ayant planté",
       x = "Entité planteuse de l'arbre",
       y = "Nombre d'arbres",
       fill = "Entité planteuse de l'arbre") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))