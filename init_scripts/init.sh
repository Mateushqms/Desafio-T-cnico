#!/bin/bash
set -e

echo "Criando databases e roles personalizados"

# Percorre todas as variáveis de ambiente que começam com POSTGRES_USER_
for var in $(env | grep ^POSTGRES_USER_ | awk -F= '{print $1}'); do
  # Extrai o prefixo (ex: "AIRFLOW" ou "SUPERSET")
  prefix=$(echo "$var" | cut -d'_' -f3)
  
  user=$(eval echo "\$POSTGRES_USER_${prefix}")
  password=$(eval echo "\$POSTGRES_PASSWORD_${prefix}")
  database=$(eval echo "\$POSTGRES_DATABASE_${prefix}")

  echo "Verificando e criando usuário e database para $prefix..."

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- 1. Cria a role (usuário) apenas se ela não existir
    DO
    \$do\$
    BEGIN
       IF NOT EXISTS (
          SELECT FROM pg_catalog.pg_roles
          WHERE  rolname = '$user') THEN

          CREATE ROLE $user WITH LOGIN PASSWORD '$password';
       END IF;
    END
    \$do\$;

    -- 2. Cria o database apenas se ele não existir
    -- usa o \gexec pois CREATE DATABASE não pode ser executado em um bloco de transação (DO/BEGIN)
    SELECT 'CREATE DATABASE $database OWNER $user'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$database')\gexec

    GRANT ALL PRIVILEGES ON DATABASE $database TO $user;
EOSQL
done

echo "Configuração de roles e databases concluída"


# -- CREATE DATABASE airflow_meta;
# -- CREATE DATABASE superset_meta;
# -- CREATE DATABASE analytics;


# #!/bin/bash
# set -e

# psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
#   CREATE DATABASE airflow;
#   CREATE DATABASE superset;
#   CREATE DATABASE data_warehouse;

#   CREATE ROLE airflow_user WITH LOGIN PASSWORD 'airflow_password';
#   CREATE ROLE superset_user WITH LOGIN PASSWORD 'superset_password';
#   CREATE ROLE data_warehouse_user WITH LOGIN PASSWORD 'dw_password';

#   GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow_user;
#   GRANT ALL PRIVILEGES ON DATABASE superset TO superset_user;
#   GRANT ALL PRIVILEGES ON DATABASE data_warehouse TO data_warehouse_user;

# EOSQL