# airflow-etl
Airflow setup for ETL

## Install
<pre>pip install airflow
</pre>

## Config
Setup in `.bashrc` or `.zshrc ` your `AIRFLOW_HOME` e.g.
<pre>export AIRFLOW_HOME=/Users/your_user/airflow-etl
</pre>

## Init and Start
<pre># check the version
airflow version # it will init default files in the AIRFLOW_HOME

# init db
airflow initdb

# start server
airflow webserver 
</pre>

## Getting start
* create a folder called `dags` inside `AIRFLOW_HOME`
* create a job inside `hello_world.py`
* `airflow scheduler`