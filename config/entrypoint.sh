#!/usr/bin/env bash

# copy files in EFS volume
cp -R /dags/* /usr/local/airflow/dags/

# start Airflow service as per 
#the previous parameter in command container
case "$1" in
  webserver)
        airflow db init \
        && airflow users create \
        --role Admin \
        --username airflow \
        --password airflow \
        --email airflow@example.com \
        --firstname airflow \
        --lastname airflow 
		sleep 5
    exec airflow webserver
    ;;
  scheduler)
    sleep 15
    exec airflow "$@"
    ;;
  worker)
    sleep 15
    exec airflow celery "$@"
    ;;
  flower)
    sleep 15
    exec airflow celery "$@"
    ;;
  version)
    exec airflow "$@"
    ;;
  *)
    exec "$@"
    ;;
esac
