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
    print('true')
if args.model == 'svm':
    print('true')
if args.model == 'rf':
    print('false')
if args.model == 'mlp':
    print('true')
