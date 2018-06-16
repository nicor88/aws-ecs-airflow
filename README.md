# airflow-etl
Airflow setup to run ETL jobs

## Getting start

### Requirements
* Docker

### Start Airflow Locally
When starting Airflow locally the Docker image **airflow:latest** is build first. This will require a while before having Airflow running.
<pre>
make start
</pre>
If everything runs correctly you can reach Airflow navigating to [localhost:8080](http://localhost:8080).
The current setup is based on CeleryWorkers. You can monitor how many workers are currently active going to [localhost:5555](http://localhost:5555)

### Stop Airflow Locally
<pre>
make stop
</pre>

### Clean-up

It will delete all the local Postgress Data and clean up the airflow Images from Docker.
<pre>
make clean
</pre>

## Resources

### Articles
* [Developing Workflows with Apache Airflow](http://michal.karzynski.pl/blog/2017/03/19/developing-workflows-with-apache-airflow/)
* [Installing Apache Airflow on Ubuntu/AWS](https://medium.com/a-r-g-o/installing-apache-airflow-on-ubuntu-aws-6ebac15db211)
* [A Guide On How To Build An Airflow Server/Cluster](https://stlong0521.github.io/20161023%20-%20Airflow.html)
* [ETL Pipelines With Airflow](http://michael-harmon.com/blog/AirflowETL.html)
* [Airflow Tutorial for Data Pipelines](https://blog.godatadriven.com/practical-airflow-tutorial)
* [Building a Data Pipeline with Airflow](http://tech.marksblogg.com/airflow-postgres-redis-forex.html)
* [PostgresOperator](https://programtalk.com/python-examples/airflow.operators.postgres_operator.PostgresOperator/)

### Video
* [A Pratctical Introduction to Airflow](https://www.youtube.com/watch?v=cHATHSB_450)
* [Modern ETL-ing with Python and Airflow (and Spark)](https://www.youtube.com/watch?v=tcJhSaowzUI)
