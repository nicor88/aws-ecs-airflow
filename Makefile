airflow-up:
	@docker-compose up --build

airflow-down:
	@docker-compose down

clean:
	rm -rf postgres_data
