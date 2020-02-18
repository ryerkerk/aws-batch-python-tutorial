#!/bin/bash

# This script converts the provided environment variables to command line
# arguments for the python script. It then runs the python script and uploads
# the logs and results file to an S3 bucket.

error_exit () {
  echo "${BASENAME} - ${1}" >&2
  exit 1
}

# The following block checks if a certain environment parameter has been set,
# and if it has it will download the necessary file from the S3 bucket.
# if [ ! ${initial_model} == "none" ]; then
#   aws s3 cp "s3://<your s3 bucket>/<your folder>/${initial_model}.pt" - > "./trained_models/${initial_model}.pt" || error_exit "Failed to download initial model from s3 bucket."
# fi


# When the argparse package is used it will produce a list of command Line
# arguments when the --help commmand is invoked (python3 script.py --help)
#
# The next block of code will parse the output of this command to get a list of
# the command line arguments. If the names of any environmental variables match
# the command line arguments then that value will be passed to the python script
pat="--([^ ]+).+"
arg_list=""
while IFS= read -r line; do
    # Check if line contains a command line argument
    if [[ $line =~ $pat ]]; then
      E=${BASH_REMATCH[1]}
      # Check that a matching environmental variable is declared
      if [[ ! ${!E} == "" ]]; then
        # Make sure argument isn't already include in argument list
        if [[ ! ${arg_list} =~ "--${E}=" ]]; then
          # Add to argument list
          arg_list="${arg_list} --${E}=${!E}"
        fi
      fi
    fi
done < <(python3 script.py --help)

# Run the python script with the parsed argument list.
# Save the outputs to <save_name>.txt
python3 -u script.py ${arg_list} | tee "${save_name}.txt"

# Upload results and logs to the S3 bucket
aws s3 cp "./${save_name}.p" "s3://<your S3 bucket>/results/${save_name}.p" || error_exit "Failed to upload results to s3 bucket."
aws s3 cp "./${save_name}.txt" "s3://<your S3 bucket>/logs/${save_name}.txt" || error_exit "Failed to upload logs to s3 bucket."
