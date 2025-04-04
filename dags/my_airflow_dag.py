from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2025, 1, 1),
    'retries': 1,
}

dag = DAG(
    'spark_processing',
    default_args=default_args,
    schedule_interval='@daily',
)

run_spark = BashOperator(
    task_id='run_spark_job',
    bash_command='spark-submit --master local /path/to/spark_job.py',
    dag=dag,
)