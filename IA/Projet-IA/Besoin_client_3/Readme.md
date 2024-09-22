# Besoin client 3
---

Mise en place d'un système d'alerte pour prédire les arbres suceptibles d'être deracinnées en cas de tempête.

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
pip install numpy pandas scikit-learn matplotlib seaborn plotly nbformat imblearn joblib json argparse
```

## Utilisation du script

Le script prend en argument un fichier json avec la liste des arbres à afficher sur la carte et affiche leur état suite à le tempête.
Essouché pour déraciné et non essouché si la tempête n'a pas impacter.

```bash
.venv/bin/python3 Besoin_client_3/final.py "Besoin_client_3/Data_arbre.json"
```