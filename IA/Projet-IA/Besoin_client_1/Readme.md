# Besoin client 1
---

Visualisation des arbres sur une carte séparé par leurs tailles selon le nombre de division choisi par l'utilisateur.

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
pip install pip install scikit-learn pandas matplotlib ipywidgets IPython plotly
```

## Utilisation du script

Le script ne prend aucun argument mais un input demandera le nombre de division souhaité pour afficher les arbres sur la carte.

```bash
.venv/bin/python3 Besoin_client_1/final.py
```