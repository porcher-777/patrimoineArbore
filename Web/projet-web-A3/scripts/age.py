# Imports.
import argparse

def checkArguments():
    """Check program arguments and return program parameters."""
    parser = argparse.ArgumentParser()
    parser.add_argument('-m', '--model', type=str, required=True, help='model')
    return parser.parse_args()

# Main program.
args = checkArguments()
if args.model == 'knn':
    print(30)
if args.model == 'svm':
    print(15)
if args.model == 'rf':
    print(25)
if args.model == 'mlp':
    print(23)
