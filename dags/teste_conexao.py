from airflow import DAG
from airflow.operators.python import PythonOperator
import psycopg2
from datetime import datetime

def teste_conexao():
    conn = psycopg2.connect(
        host="postgres",
        dbname="analytics",
        user="admin",
        password="admin",
        port=5432
    )
    cur = conn.cursor()
    cur.execute("SELECT NOW();")
    resultado = cur.fetchone()
    print("Resultado da query:", resultado)
    cur.close()
    conn.close()

with DAG(
    dag_id="teste_postgres",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False
) as dag:

    teste_task = PythonOperator(
        task_id="teste_conexao_postgres",
        python_callable=teste_conexao
    )
