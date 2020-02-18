FROM python:3.6.10-alpine

# Install python and any other necessary dependencies
# awscli is necessary for the run_job.sh script to access S3 resources
RUN pip3 install awscli;

# Alpine image doesn't automatically come with bash
RUN apk add --no-cache --upgrade bash

# Copy the local folder to the Docker image
COPY ./ /usr/local/aws_batch_tutorial

# Set the working directory to the newly created folder
WORKDIR /usr/local/aws_batch_tutorial
