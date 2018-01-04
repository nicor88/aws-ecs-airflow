import sys

from datetime import datetime
from airflow import utils
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
import logging

log = logging.getLogger(__name__)

default_args = {
    'owner': 'nicor88',
    'start_date': datetime(2017, 12, 25),
    'depends_on_past': False,
    'provide_context': True
}

dag_input = {'report_date':  utils.dates.days_ago(1)}


def task_1(**kwargs):
    output = {'key1': 'hello world 1', 'execution_time': datetime.now()}
    print(output)
    kwargs['ti'].xcom_push(key='output', value=output)


def task_2(**kwargs):
    print(kwargs)
    ti = kwargs['ti']
    value = ti.xcom_pull(key='output', task_ids='task_1')
    print(value)

    return {'output': 'Hello world from task 2'}


dag = DAG('my_first_dag', description='Simple tutorial DAG',
          schedule_interval='*/1 * * * *', catchup=False, default_args=default_args)

t1 = PythonOperator(
    task_id='task_1',
    dag=dag,
    python_callable=task_1,
    op_kwargs=dag_input,
    xcom_push=True
)
t2 = PythonOperator(
    task_id='task_2',
    dag=dag,
    python_callable=task_2,
    op_kwargs=dag_input,
    xcom_push=True)

#t1 >> t2
t2.set_upstream(t1)
