FROM apache/airflow:slim-2.8.1-python3.11

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER airflow

RUN pip install --no-cache-dir \
    apache-airflow-providers-postgres==5.9.0 \
    psycopg2-binary
    
WORKDIR ${AIRFLOW_HOME}

