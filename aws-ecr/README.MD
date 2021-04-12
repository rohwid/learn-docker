# **Working with Docker and ECR as registry in AWS**

Here's the step to start working with AWS ECR.

## **Private Registry Authentication**

To push or pull the image you need to set the [Private registry authenticator](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html) first.

    $ aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com

For example:

    $ aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 092801943936.dkr.ecr.ap-southeast-1.amazonaws.com

## **Pushing Docker Images**

To [push the image](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html) here the command.

First thing to do is create the ECR repository and it's name:

    $ aws ecr create-repository --repository-name ${reponame} --region ${region}

For example:

    $ aws ecr create-repository --repository-name ner-project --region ap-southeast-1

Set the tag for the repository:

    $ docker tag ${reponame}:${version} ${fullname}

For example:

    $ docker tag ner-project:0.0.1 ner-project

Push the docker:

    $ docker push ${repository}:${version}

For example:

    $ docker tag ner-project:0.0.1 ner-project

## **Pulling Docker Images**

To [pull the image](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-pull-ecr-image.html) here the command.

Here's the optional command to check the `aws ecr repository`:

To describe all repository, here's the command:

    $ aws ecr describe-repositories

Then choose one repository to get the specific info about that reposiory:

    $ aws ecr describe-images --repository-name ${repository name}

If you wanna pull that imaga just use this command:

    $ docker pull ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/${repository}:${version}
