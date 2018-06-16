.EXPORT_ALL_VARIABLES:

STACK_NAME = airflow-ecs
IMAGE_NAME = airflow
AWS_ACCOUNT = 749785218022
AWS_REGION = us-east-1
AUTH = $(shell aws --profile nicor88 ecr get-login --no-include-email)

default: build_locally

build_locally:
	docker build --rm -t $$IMAGE_NAME:latest .

auth:
	$$AUTH

push_remote: build_locally auth
	docker tag $$IMAGE_NAME $$AWS_ACCOUNT.dkr.ecr.$$AWS_REGION.amazonaws.com/airflow
	docker push $$AWS_ACCOUNT.dkr.ecr.$$AWS_REGION.amazonaws.com/airflow
	@echo "Pushed to ECR"

start: build_locally
	docker-compose up -d
	@echo "Airflow up"

stop:
	docker-compose down
	@echo "Airflow down"

clean:
	rm -rf postgres_data
	@echo "Postgres data cleaned"
	docker rmi airflow
	@echo "Docker Airflow images removed"
