# airflow-etl
Airflow setup for ETL

## Init and Start

### Docker

#### Build
<pre>
docker build --rm -t nicor88/docker-airflow .
</pre>

#### Run
<pre># start docker daemon
# run docker compose
docker-compose up -d

# stop docleker compose
docker-compose down
</pre>

### AWS ECR
<pre>
eval $(aws --profile nicor88 ecr get-login --no-include-email)
docker build --rm=True -t airflow .
docker tag airflow 749785218022.dkr.ecr.eu-west-1.amazonaws.com/airflow
docker push 749785218022.dkr.ecr.eu-west-1.amazonaws.com/airflow
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
