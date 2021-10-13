# Airflow 2.0 in AWS ECS Fargate
Setup to run Airflow in AWS ECS containers

## Requirements

### Local
* Docker
* Docker Compose

### AWS
* AWS IAM User for the infrastructure deployment, with admin permissions
* [awscli](https://aws.amazon.com/cli/), intall running `pip install awscli`
* [terraform >= 0.13](https://www.terraform.io/downloads.html)
* setup your IAM User credentials inside `~/.aws/credentials`
* setup these env variables in your .zshrc or .bashrc, or in your the terminal session that you are going to use
  <pre>
  export AWS_ACCOUNT=your_account_id
  export AWS_DEFAULT_REGION=us-east-1 # it's the default region that needs to be setup also in infrastructure/config.tf
  </pre>


## Local Development
* Generate a Fernet Key:
  <pre>
  pip install cryptography
  export AIRFLOW_FERNET_KEY=$(python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())")
  </pre>
  More about that [here](https://cryptography.io/en/latest/fernet/)

* Start Airflow locally simply running:
  <pre>
  docker-compose up --build
  </pre

If everything runs correctly you can reach Airflow navigating to [localhost:8080](http://localhost:8080).
The current setup is based on [Celery Workers](https://airflow.apache.org/howto/executor/use-celery.html). You can monitor how many workers are currently active using Flower, visiting [localhost:5555](http://localhost:5555)

## Deploy Airflow 2.0 on AWS ECS
To run Airflow in AWS we will use ECS (Elastic Container Service) with components in AWS:
* AWS ECS Fargate: run all Airflow services (Webserver, Flower, Workers and Scheduler);
* ElasticCache (Redis): communication between Airflow Services;
* RDS for Postgres: database MetadataDB for Airflow servies;
* EFS: persistent storage for Airflow dags;
* ELB: Application Load Balance for Airflow WebServer access;
* CloudWatch: logs for container services and Airflow run tasks;
* IAM: communications services permission for ECS containers;
* ECR: image repository Docker for storage Airflow images. 

### Deploy Infrastructure using Terraform
Run the following commands:

Exports System Variables:

```sh
export AWS_ACCOUNT=xxxxxxxxxxxxx
export AWS_DEFAULT_REGION=us-east-1
```
And build all infraestructure and upload Docker Image:

```sh
bash scripts/deploy.sh airflow-dev
```
By default the infrastructure is deployed in `us-east-1`.

The file that runs all airflow services is entrypoint.sh located in the configs folder under the project root.
It is parameterized according to the commands passed in tasks definitions called command.

## Troubleshooting

If when uploading the Airflow containers an error occurs such as:
`ResourceInitializationError: failed to invoke EFS utils commands to set up EFS volumes: stderr: b'mount.nfs4...`

You will need to mount the EFS on an EC2 instance and perform the following steps:

* mount the EFS on an EC2 in the same VPC;
* access EFS and create the **/data/airflow folder** structure;
* give full and recursive permission on the root folder, something like **chmod 777 -R /data**.
* with this the AIRflow containers will be able to access the volume and create the necessary folders;

## TODO
* refact terraform on best practices;
* use SSM Parameter Store to keep passwords secret;
* automatically update task definition when uploading a new Airflow version.
