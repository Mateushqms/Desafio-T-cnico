FROM apache/airflow:2.8.1-python3.11

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER airflow
WORKDIR ${AIRFLOW_HOME}