# Projet Web A3

---

Site web pour visualiser les arbres et effectuer des prédictions sur le
patrimoine arboré de la ville de Saint-Quentin.

## Installation

Pour ajouter la base de donnée à votre serveur, vous pouvez utilisez la
commande suivante dans mysql:

```sql
source src/sql/db-scheme.sql
```

Si vous avez besoin de créer un compte vous pouvez utiliser le script sql
`src/sql/adduser.sql`.

### Remplir la BDD

Le script python `script/import.py` permet d'ajouter les données dans la BDD
depuis un fichier csv.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install argparse pandas mysql-connector-python
```

Pour utiliser ce script utiliser la commande suivante:

```bash
.venv/bin/python3 scripts/import.py assets/Data_Arbre.csv
```

## Maquette & MCD

Le MCD est disponible sous le fichier `projetweb_trinome1.mcd`, et la maquette
est disponbile sur [figma](https://www.figma.com/design/QCQlzCoyZcN3SnloqAFAnX/Untitled?node-id=0-1&t=U39GZnjTTXRKUf6q-1).

## Ressources

### Logiciels utilisés

- [Figma](https://www.figma.com/) pour la conception de la maquette  
- [JMerise](https://www.jfreesoft.com/JMerise/) pour la conception du MCD / MPD
- [Swagger](https://editor.swagger.io/) pour l'interface client-serveur  

