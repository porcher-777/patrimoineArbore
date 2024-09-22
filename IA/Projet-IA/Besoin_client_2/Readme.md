# Besoin client 2
---

Mise en place d'un modèle capable de prédire l'âge des arbres.

## Création d'un environnement virtuel

Il est préférable d'utiliser un environnement virtuel pour utiliser le projet python.

```bash
python -m venv .venv
```

## Installation des librairies

Activation du terminal python pour installer des libraires avec pip:  

```bash
source .venv/bin/activate
```

Puis il suffit d'installer les librairies nécessaires pour le script:

```bash
pip install pandas scikit-learn numpy scipy joblib matplotlib statsmodels joblib json seaborn argparse
```

## Utilisation du script

Le script prend en argument un fichier JSON avec la liste des arbres dont nous souhaitons prédire l'âge et retourne cela dans un fichier JSON.

```bash
.venv/bin/python3 Besoin_client_2/final.py "Besoin_client_2/Data_arbre.json"
```