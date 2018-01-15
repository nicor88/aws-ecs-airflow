# airflow-etl
Airflow setup for ETL

## Install
<pre>pip install "apache-airflow"
pip install "apache-airflow[postgres,s3]"
</pre>

## Config
Setup in `.bashrc` or `.zshrc ` your `AIRFLOW_HOME` e.g.
<pre>export AIRFLOW_HOME=/Users/your_user/airflow-etl
</pre>

## Init and Start

### Locally
<pre># check the version
airflow version # it will init default files in the AIRFLOW_HOME

# init db
airflow initdb

# start worker
airflow worker

# start server
airflow webserver

# start scheduler
airflow scheduler

# kill everything running
pkill -f airflow
</pre>

### Docker
<pre># start docker daemon
# run docker compose
docker-compose up -d

# stop docleker compose
docker-compose down
</pre>

## Resources

### Articles
* [Installing Apache Airflow on Ubuntu/AWS](https://medium.com/a-r-g-o/installing-apache-airflow-on-ubuntu-aws-6ebac15db211)
* [A Guide On How To Build An Airflow Server/Cluster](https://stlong0521.github.io/20161023%20-%20Airflow.html)
* [ETL Pipelines With Airflow](http://michael-harmon.com/blog/AirflowETL.html)
* [Airflow Tutorial for Data Pipelines](https://blog.godatadriven.com/practical-airflow-tutorial)
* [Building a Data Pipeline with Airflow](http://tech.marksblogg.com/airflow-postgres-redis-forex.html)
* [PostgresOperator](https://programtalk.com/python-examples/airflow.operators.postgres_operator.PostgresOperator/)

### Video
* [A Pratctical Introduction to Airflow](https://www.youtube.com/watch?v=cHATHSB_450)
* [Modern ETL-ing with Python and Airflow (and Spark)](https://www.youtube.com/watch?v=tcJhSaowzUI)
