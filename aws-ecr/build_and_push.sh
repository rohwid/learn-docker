#!/bin/bash

# Construct the ECR name.
aws_account_id=$(aws sts get-caller-identity --query Account --output text)
echo "[DEBUG] AWS account name: " ${aws_account_id}

region=$(aws configure get region)
echo "[DEBUG] AWS region: " ${region}

reponame="ner-project"
version="0.0.2"
publish_port="8080"
local_port="8080"

fullname="${aws_account_id}.dkr.ecr.${region}.amazonaws.com/${reponame}:${version}"
echo "[DEBUG] Image name: " ${fullname}

# Build the docker image
docker build --tag ${fullname} .

read -n1 -r -p "Run the image localy. press ENTER to continue!" ENTER

# Run the docker image localy
docker run --name ${reponame} --publish ${publish_port}:${local_port} --detach ${fullname}

read -n1 -r -p "Push the image to the ECR. press ENTER to continue!" ENTER

# Get the login command from ECR and execute it directly
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com

# create the repository in ECR.
aws ecr create-repository --repository-name ${reponame} --region ${region}

# Tag it with the full name
docker tag ${reponame}:${version} ${fullname}

# And push it to ECR
docker push ${fullname}
