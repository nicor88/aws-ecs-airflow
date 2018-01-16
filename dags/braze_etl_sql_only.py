from datetime import datetime
import logging

from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.postgres_operator import PostgresOperator
from airflow.hooks.postgres_hook import PostgresHook

logger = logging.getLogger(__name__)

default_args = {
    'owner': 'nicor88',
    'start_date': datetime(2017, 12, 25),
    'depends_on_past': False,
    'provide_context': True
}


def get_max_source_populated_at(**kwargs):
    hook = PostgresHook(postgres_conn_id='redshift_nicola',
                        schema='dev')
    sql = 'SELECT max(source_populated_at) FROM nico_dev.braze_campaigns_analytics_fact'
    max_source_populated_at = hook.get_first(sql, parameters=None)[0] or datetime(2016, 12, 31)
    output = {'max_source_populated_at': max_source_populated_at}
    kwargs['ti'].xcom_push(key='output', value=output)
    logger.info(output)
    return output


def insert_to_staging(**kwargs):
    ti = kwargs['ti']
    max_source_populated_at = ti.xcom_pull(key='return_value', task_ids='get_max_source_populated_at').get(
        'max_source_populated_at')
    logger.info(max_source_populated_at)
    hook = PostgresHook(postgres_conn_id='redshift_nicola',
                        schema='dev', keepalives_idle=60)
    sql = """INSERT INTO nico_dev.staging_braze_campaigns_analytics
              SELECT * FROM braze.campaigns_analytics
              WHERE populated_at > %(max_source_populated_at)s"""
    result = hook.run(sql, True, parameters={'max_source_populated_at': max_source_populated_at})
    logger.info(result)


# run every day at 10:15
dag = DAG('braze_etl_sql_only', description='ETL to replace Matillion Braze ETL',
          schedule_interval='15 10 * * *', catchup=False, default_args=default_args)

truncate_table_task = PostgresOperator(
    task_id='truncate_staging_table',
    postgres_conn_id='redshift_nicola',
    database='dev',
    sql='TRUNCATE TABLE nico_dev.staging_braze_campaigns_analytics',
    autocommit=True,
    dag=dag
)

get_max_source_populated_at_task = PythonOperator(
    task_id='get_max_source_populated_at',
    dag=dag,
    python_callable=get_max_source_populated_at
)

insert_to_staging_task = PythonOperator(
    task_id='insert_to_staging_task',
    dag=dag,
    python_callable=insert_to_staging
)

clean_fact = PostgresOperator(
    task_id='clean_fact',
    postgres_conn_id='redshift_nicola',
    database='dev',
    sql="""DELETE FROM nico_dev.braze_campaigns_analytics_fact
              USING nico_dev.staging_braze_campaigns_analytics 
              WHERE braze_campaigns_analytics_fact.date_sk=staging_braze_campaigns_analytics.date_sk 
                    AND braze_campaigns_analytics_fact.campaign_id = staging_braze_campaigns_analytics.campaign_id
                    AND braze_campaigns_analytics_fact.variation_name = staging_braze_campaigns_analytics.variation_name
                    AND braze_campaigns_analytics_fact.message_type = staging_braze_campaigns_analytics.message_type
    """,
    autocommit=True,
    dag=dag
)

insert_to_fact = PostgresOperator(
    task_id='insert_to_fact',
    postgres_conn_id='redshift_nicola',
    database='dev',
    sql="""INSERT INTO nico_dev.braze_campaigns_analytics_fact
                SELECT
                date_sk,
                campaign_id,
                campaign_name,
                message_type,
                variation_name,
                sent,
                bounces,
                revenue,
                unique_recipients,
                clicks,
                conversions,
                conversions1,
                conversions2,
                conversions3,
                opens,
                unique_opens,
                unique_clicks,
                unsubscribes,
                delivered,
                reported_spam,
                direct_opens,
                total_opens,
                body_clicks,
                impressions,
                enrolled,
                first_button_clicks,
                second_button_clicks,
                is_canvas_campaign,
                canvas_id,
                canvas_name,
                populated_at as source_populated_at
            FROM (
              SELECT *,
              ROW_NUMBER()
                OVER (
                  PARTITION BY date_sk, campaign_id, message_type, variation_name
                  ORDER BY populated_at DESC ) AS row_number
              FROM nico_dev.staging_braze_campaigns_analytics
            ) AS t
            WHERE row_number = 1
    """,
    autocommit=True,
    dag=dag
)


get_max_source_populated_at_task.set_upstream(truncate_table_task)
insert_to_staging_task.set_upstream(get_max_source_populated_at_task)
clean_fact.set_upstream(insert_to_staging_task)
insert_to_fact.set_upstream(clean_fact)
