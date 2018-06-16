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
    output = {'key': 'hello world from task 1', 'execution_time': datetime.now()}
    kwargs['ti'].xcom_push(key='output', value=output)


def task_2(**kwargs):
    output = {'key': 'hello world rom task 2', 'execution_time': datetime.now()}
    kwargs['ti'].xcom_push(key='output', value=output)


def task_3(**kwargs):
    output = {'key': 'hello world rom task 3', 'execution_time': datetime.now()}
    kwargs['ti'].xcom_push(key='output', value=output)


def task_4(**kwargs):
    output = {'key': 'hello world rom task 4', 'execution_time': datetime.now()}
    kwargs['ti'].xcom_push(key='output', value=output)


def task_5(**kwargs):
    output = {'key': 'hello world rom task 5', 'execution_time': datetime.now()}
    kwargs['ti'].xcom_push(key='output', value=output)


def task_6(**kwargs):
    output = {'key': 'hello world rom task 6', 'execution_time': datetime.now()}
    kwargs['ti'].xcom_push(key='output', value=output)


def task_7(**kwargs):
    output = {'key': 'hello world rom task 7', 'execution_time': datetime.now()}
    kwargs['ti'].xcom_push(key='output', value=output)


def task_8(**kwargs):
    ti = kwargs['ti']
    output = {'key': 'hello world rom task 8', 'execution_time': datetime.now()}
    print(output)
    value = ti.xcom_pull(key='output', task_ids='task_1')
    print(value)


dag = DAG('complex_dag', description='Complex DAG',
          schedule_interval='*/5 * * * *', catchup=False, default_args=default_args)

t1 = PythonOperator(
    task_id='task_1',
    dag=dag,
    python_callable=task_1,
    op_kwargs=dag_input
)

t2 = PythonOperator(
    task_id='task_2',
    dag=dag,
    python_callable=task_2,
    op_kwargs=dag_input,
    )

t3 = PythonOperator(
    task_id='task_3',
    dag=dag,
    python_callable=task_3,
    op_kwargs=dag_input,
    )

t3.set_upstream([t1, t2])


t4 = PythonOperator(
    task_id='task_4',
    dag=dag,
    python_callable=task_4,
    op_kwargs=dag_input,
    )

t4.set_upstream(t3)


t5 = PythonOperator(
    task_id='task_5',
    dag=dag,
    python_callable=task_5,
    op_kwargs=dag_input,
    )

t6 = PythonOperator(
    task_id='task_6',
    dag=dag,
    python_callable=task_6,
    op_kwargs=dag_input,
    )

t4.set_downstream([t5, t6])

t7 = PythonOperator(
    task_id='task_7',
    dag=dag,
    python_callable=task_7,
    op_kwargs=dag_input,
    )

t8 = PythonOperator(
    task_id='task_8',
    dag=dag,
    python_callable=task_8,
    op_kwargs=dag_input,
)

t8.set_upstream([t5, t6, t7])
