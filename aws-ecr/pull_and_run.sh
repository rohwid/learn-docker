#!/bin/bash

# Construct the ECR name.
aws_account_id=$(aws sts get-caller-identity --query Account --output text)
echo "[DEBUG] AWS account name: " ${aws_account_id}

region=$(aws configure get region)
echo "[DEBUG] AWS region: " ${region}

reponame="ner-project"
version="0.0.2"
publish_port="5000"
local_port="8080"

fullname="${aws_account_id}.dkr.ecr.${region}.amazonaws.com/${reponame}:${version}"
echo "[DEBUG] Image name: " ${fullname}

# Pull the docker image
sudo docker pull ${fullname}

# Run the docker container
sudo docker run --name ${reponame} --publish ${publish_port}:${local_port} --detach ${fullname}
