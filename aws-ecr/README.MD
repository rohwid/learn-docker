# Working with Docker and ECR as registry in AWS

Here's the step to start working with AWS ECR.

## Private Registry Authentication

To pull or pull the image you need to set 

aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com