default: build_locally

build_locally:
	docker build --rm -t nicor88/docker-airflow:latest .
	@echo "Airflow image build"


start:
	docker-compose up -d
	@echo "Airflow up"

clean:
	docker-compose down
	@echo "Airflow down"