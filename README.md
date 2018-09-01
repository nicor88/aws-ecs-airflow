# airflow-ecs
Setup to run Airflow in AWS ECS containers

## Requirements
* Docker
* [awscli](https://aws.amazon.com/cli/)
* AWS IAM User

## Local Development
It's possible to start Airflow locally simply running:
```
docker-compose up --build
```
If everything runs correctly you can reach Airflow navigating to [localhost:8080](http://localhost:8080).
The current setup is based on CeleryWorkers. You can monitor how many workers are currently active using Flower, visiting [localhost:5555](http://localhost:5555)

## Deploy Airflow in AWS ECS
To run Airflow in AWS we will use ECS (Elastic Container Service).
To deploy Airflow setup we need first to create the container repository for our Docker Images.

We will user ECR (Elastic Container Repository).
* Create a new repository using:
	```
	aws ecr create-repository --repository-name airflow-ecs --profile your_aws_profile
	```
* Login to ECR
  ```
  eval $(aws ecr get-login --no-include-email --profile your_aws_profile)

  ```
* Build the image locally:
  ```
  docker build -t airflow-ecs .

  ```

* Push Airflow Image to ECR:
  ```
  docker tag airflow-ecs:latest your_aws_account_number.dkr.ecr.your_aws_region.amazonaws.com/airflow-ecs:latest
  docker push your_aws_account_number.dkr.ecr.your_aws_region.amazonaws.com/airflow-ecs:latest

  ```
  **NOTE**: replace _your_aws_account_number_ and _your_aws_region_

Now that Airflow Image is pushed to ECR we can create our Infrastructure using Cloudformation.
```
cd infrastructure
AWS_DEFAULT_PROFILE=nicor88 make create
```

### Clean up
```
cd infrastructure
AWS_DEFAULT_PROFILE=nicor88 make clean
```