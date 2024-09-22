# Imports.
import random
import json
import sys

def generate_random_list(size):
    """Generate a list of random int of size size"""
    return [random.randint(1, 5) for _ in range(size)]


if len(sys.argv) != 2:
    print("Usage: python clusters.py <nb_arbre>")
    sys.exit(1)

nb_arbre = int(sys.argv[1])
    
result = generate_random_list(nb_arbre)
print(json.dumps(result))
