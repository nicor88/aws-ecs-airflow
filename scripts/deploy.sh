#!/usr/bin/env bash
IMAGE_NAME=$1

# Deploy Terraform
cd infrastructure
terraform init
terraform apply -var "image_version=latest" -auto-approve
#terraform destroy -var "image_version=latest" -auto-approve

cd ..

### ECR - build images and push to remote repository
echo "Building image: $IMAGE_NAME:latest"

docker build --rm -t $IMAGE_NAME:latest .

eval $(aws ecr get-login-password)

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

# tag and push image using latest
docker tag $IMAGE_NAME $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest
docker push $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest
