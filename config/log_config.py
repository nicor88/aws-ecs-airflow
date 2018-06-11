import os

from airflow import configuration as conf

S3_LOG_FOLDER = 's3://nicor88-airflow/'

# TODO: Logging format and level should be configured
# in this file instead of from airflow.cfg. Currently
# there are other log format and level configurations in
# settings.py and cli.py. Please see AIRFLOW-1455.
LOG_LEVEL = conf.get('core', 'LOGGING_LEVEL').upper()


# Flask appbuilder's info level log is very verbose,
# so it's set to 'WARN' by default.
FAB_LOG_LEVEL = 'WARN'

LOG_FORMAT = conf.get('core', 'LOG_FORMAT')

BASE_LOG_FOLDER = conf.get('core', 'BASE_LOG_FOLDER')

PROCESSOR_LOG_FOLDER = conf.get('scheduler', 'CHILD_PROCESS_LOG_DIRECTORY')

FILENAME_TEMPLATE = '{{ ti.dag_id }}/{{ ti.task_id }}/{{ ts }}/{{ try_number }}.log'

PROCESSOR_FILENAME_TEMPLATE = '{{ filename }}.log'

LOG_ID_TEMPLATE = '{dag_id}-{task_id}-{execution_date}-{try_number}'

# Storage bucket url for remote logging
# s3 buckets should start with "s3://"
# gcs buckets should start with "gs://"
# wasb buckets should start with "wasb"
# just to help Airflow select correct handler
# REMOTE_BASE_LOG_FOLDER = conf.get('core', 'REMOTE_BASE_LOG_FOLDER')

# ELASTICSEARCH_HOST = conf.get('elasticsearch', 'ELASTICSEARCH_HOST')

END_OF_LOG_MARK = 'end_of_log'

LOGGING_CONFIG = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'airflow': {
            'format': LOG_FORMAT,
        },
    },
    'handlers': {
        'console': {
            'class': 'airflow.utils.log.logging_mixin.RedirectStdHandler',
            'formatter': 'airflow',
            'stream': 'sys.stdout'
        },
        'task': {
            'class': 'airflow.utils.log.file_task_handler.FileTaskHandler',
            'formatter': 'airflow',
            'base_log_folder': os.path.expanduser(BASE_LOG_FOLDER),
            'filename_template': FILENAME_TEMPLATE,
        },
        'processor': {
            'class': 'airflow.utils.log.file_processor_handler.FileProcessorHandler',
            'formatter': 'airflow',
            'base_log_folder': os.path.expanduser(PROCESSOR_LOG_FOLDER),
            'filename_template': PROCESSOR_FILENAME_TEMPLATE,
        },
        's3.task': {
            'class': 'airflow.utils.log.s3_task_handler.S3TaskHandler',
            'formatter': 'airflow.task',
            'base_log_folder': os.path.expanduser(BASE_LOG_FOLDER),
            's3_log_folder': S3_LOG_FOLDER,
            'filename_template': FILENAME_TEMPLATE,
        }
    },
    'loggers': {
        'airflow.processor': {
            'handlers': ['processor'],
            'level': LOG_LEVEL,
            'propagate': False,
        },
        'airflow.task': {
            'handlers': ['s3.task'],
            'level': LOG_LEVEL,
            'propagate': False,
        },
        'airflow.task_runner': {
            'handlers': ['s3.task'],
            'level': LOG_LEVEL,
            'propagate': False,
        },
        'flask_appbuilder': {
            'handler': ['console'],
            'level': FAB_LOG_LEVEL,
            'propagate': True,
        }
    },
    'root': {
        'handlers': ['console'],
        'level': LOG_LEVEL,
    }
}
