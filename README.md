# airflow-ecs
Setup to run Airflow in AWS ECS containers

## Requirements
* Docker
* [awscli](https://aws.amazon.com/cli/)
* an AWS IAM User for the deployment
* setup your IAM User credentials inside `~/.aws/credentials`


## Local Development
It's possible to start Airflow locally simply running:
```
export AIRFLOW_FERNET_KEY="your_fernet_key" # more about that here https://cryptography.io/en/latest/fernet/
docker-compose up --build
```
If everything runs correctly you can reach Airflow navigating to [localhost:8080](http://localhost:8080).
The current setup is based on [Celery Workers](https://airflow.apache.org/howto/executor/use-celery.html). You can monitor how many workers are currently active using Flower, visiting [localhost:5555](http://localhost:5555)

## Deploy Airflow on AWS ECS
To run Airflow in AWS we will use ECS (Elastic Container Service).

### Deploy using Terraform
<pre>
cd infrastructure/terraform
terraform init
terraform apply
</pre>

When the infrastructure is provisioned, check the if the ECR repo is created then
<pre>
bash scripts/push_to_ecr.sh airflow-dev
</pre>
