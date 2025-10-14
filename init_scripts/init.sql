CREATE DATABASE airflow_meta;
CREATE DATABASE superset_meta;
CREATE DATABASE analytics;


-- #!/bin/bash
-- set -e

-- psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
--   CREATE DATABASE airflow;
--   CREATE DATABASE superset;
--   CREATE DATABASE data_warehouse;

--   -- Criação de roles (usuários)
--   CREATE ROLE airflow_user WITH LOGIN PASSWORD 'airflow_password';
--   CREATE ROLE superset_user WITH LOGIN PASSWORD 'superset_password';
--   CREATE ROLE data_warehouse_user WITH LOGIN PASSWORD 'dw_password';

--   -- Atribuindo permissões aos usuários para seus respectivos bancos de dados
--   GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow_user;
--   GRANT ALL PRIVILEGES ON DATABASE superset TO superset_user;
--   GRANT ALL PRIVILEGES ON DATABASE data_warehouse TO data_warehouse_user;

-- EOSQL