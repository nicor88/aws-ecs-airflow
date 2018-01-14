from datetime import datetime
import logging
import uuid

from airflow import utils
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.hooks.postgres_hook import PostgresHook
import pandas as pd

log = logging.getLogger(__name__)

default_args = {
    'owner': 'nicor88',
    'start_date': datetime(2017, 12, 25),
    'depends_on_past': False,
    'provide_context': True
}

dag_input = {'report_date': utils.dates.days_ago(1)}


def get_max_source_populated_at(**kwargs):
    print(kwargs)
    hook = PostgresHook(postgres_conn_id='redshift_nicola',
                        schema='dev')
    sql = 'SELECT max(source_populated_at) FROM nico_dev.braze_campaigns_analytics_fact'
    max_source_populated_at = hook.get_first(sql, parameters=None)[0] or datetime(2017, 1, 1)
    output = {'max_source_populated_at': max_source_populated_at}
    log.info(output)
    kwargs['ti'].xcom_push(key='output', value=output)
    return output


def extract_data(**kwargs):
    ti = kwargs['ti']
    max_source_populated_at = ti.xcom_pull(key='output', task_ids='get_max_source_populated_at').get(
        'max_source_populated_at')
    hook = PostgresHook(postgres_conn_id='redshift_nicola',
                        schema='dev', keepalives_idle=60)
    sql = """SELECT * FROM 
             braze.campaigns_analytics
             WHERE populated_at >= %(max_source_populated_at)s"""
    result_df = hook.get_pandas_df(sql, parameters={'max_source_populated_at': max_source_populated_at})
    file_name = f'{uuid.uuid4()}_{datetime.now().strftime("%Y%m%d_%H%M%S")}_braze_etl_source.pkl'
    result_df.to_pickle(file_name)
    log.info(f'Pickle written to {file_name}')
    log.info(len(result_df))
    kwargs['ti'].xcom_push(key='df_pickle_file', value=file_name)
    return {'df_pickle_file': file_name}


def transform_data(**kwargs):
    ti = kwargs['ti']
    source_df_file_path = ti.xcom_pull(key='df_pickle_file', task_ids='extract_data')
    source_df = pd.read_pickle(source_df_file_path)

    log.info(len(source_df))
    transform_df_file_path = f'{uuid.uuid4()}_{datetime.now().strftime("%Y%m%d_%H%M%S")}_braze_etl_transform.pkl'
    source_df.to_pickle(transform_df_file_path)
    log.info(f'Pickle written to {transform_df_file_path}')
    kwargs['ti'].xcom_push(key='df_pickle_file', value=transform_df_file_path)
    return {'df_pickle_file': transform_df_file_path}


def load_data(**kwargs):
    ti = kwargs['ti']
    transformed_df_file_path = ti.xcom_pull(key='df_pickle_file', task_ids='transform_data')
    transformed_df = pd.read_pickle(transformed_df_file_path)
    log.info(len(transformed_df))
    hook = PostgresHook(postgres_conn_id='redshift_nicola',
                        schema='dev', keepalives_idle=30)

    # keys = list(df.keys())
    # log.info(keys)
    # rows = [tuple(row) for row in list(df.itertuples(index=False))]
    # log.info(rows[1])
    # hook.insert_rows('dwh.braze_campaigns_analytics_fact_dev', rows, keys, commit_every=100)


dag = DAG('braze_etl', description='ETL to replace Matillion Braze ETL',
          schedule_interval='0 0 1 * *', catchup=False, default_args=default_args)

get_max_source_populated_at_task = PythonOperator(
    task_id='get_max_source_populated_at',
    dag=dag,
    python_callable=get_max_source_populated_at,
    op_kwargs=dag_input
)

extract_data_task = PythonOperator(
    task_id='extract_data',
    dag=dag,
    python_callable=extract_data,
    op_kwargs=dag_input
)

transform_data_task = PythonOperator(
    task_id='transform_data',
    dag=dag,
    python_callable=transform_data,
    op_kwargs=dag_input
)

load_data_task = PythonOperator(
    task_id='load_data',
    dag=dag,
    python_callable=load_data,
    op_kwargs=dag_input
)

extract_data_task.set_upstream(get_max_source_populated_at_task)
transform_data_task.set_upstream(extract_data_task)

load_data_task.set_upstream(transform_data_task)

