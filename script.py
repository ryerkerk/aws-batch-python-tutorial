import argparse
import pickle

def parse_arg():
    """
    This function parses command line arguments to this script
    """
    parser = argparse.ArgumentParser()

    parser.add_argument("--var_a", type=int, default=1)
    parser.add_argument("--var_b", type=int, default=2)
    parser.add_argument("--save_name", type=str,required=True)

    params = vars(parser.parse_args())

    return params

if __name__ == "__main__":
    params = parse_arg()  # Parse command line arguments

    # Use input parameters to calculate a new result
    a = params['var_a']
    b = params['var_b']
    c = a*b
    print(c)

    # Write results to file with the provided "save_name"
    pickle.dump(c, open('{}.p'.format(params['save_name']), 'wb'))
