.EXPORT_ALL_VARIABLES:

STACK_NAME = airflow-ecs
AWS_DEFAULT_PROFILE = nicor88
IMAGE_NAME = nicor88/docker-airflow

default: build_locally

build_locally:
	docker build --rm -t $$IMAGE_NAME:latest .
	@echo "Airflow image build"

push_remote: build_locally
	eval $(aws --profile $$AWS_DEFAULT_PROFILE ecr get-login --no-include-email)
	docker tag $$IMAGE_NAME 749785218022.dkr.ecr.eu-west-1.amazonaws.com/airflow
	docker push 749785218022.dkr.ecr.eu-west-1.amazonaws.com/airflow
	@echo "Pushed to ECR"

start: build_locally
	docker-compose up -d
	@echo "Airflow up"

clean:
	docker-compose down
	@echo "Airflow down"

clean_db:
	rm -rf postgres_data
	@echo "Postgres data cleaned"