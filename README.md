# Desafio Técnico — Ambiente de Desenvolvimento para Engenharia de Dados

## Visão Geral

Este projeto implementa um **ambiente de desenvolvimento para Engenharia de Dados**, orquestrado via **Docker Compose**, contendo as principais ferramentas da stack de dados:

- **Airflow** — orquestrador de tarefas e pipelines
- **Postgres** — banco de dados relacional usado como metastore e *data warehouse* (`analytics`)
- **Superset** — ferramenta de visualização e exploração de dados conectada ao Postgres

O objetivo é demonstrar **interoperabilidade entre os serviços**, validando conexões entre **Airflow ↔ Postgres** e **Superset ↔ Postgres**.

---

## Estrutura do Projeto
```
.
├── dags
│   └── teste_conexao.py
├── docker-compose.yaml
├── Dockerfile
├── evidencias
│   ├── test_airflow1.png
│   ├── test_airflow.png
│   ├── test_superset1.png
│   └── test_superset.png
├── init_scripts
│   └── init.sh
└── README.md
```
---

## Descrição dos Serviços

### Postgres

- Responsável por armazenar:
  - Metadados do **Airflow** (`airflow_meta`)
  - Metadados do **Superset** (`superset_meta`)
  - Dados de análise (`analytics`)
- Inicializa automaticamente os bancos e as roles via script `init_scripts/init.sh`

### Airflow

- Usa **Postgres** como banco de metadados
- Cria automaticamente o usuário padrão de acesso no Docker Compose nas váriaveis ambiente:
  - Usuário: `airflow`
  - Senha: `airflow`
- Executa em modo **standalone**, com webserver e scheduler ativos

### Superset

- Usa **Postgres** como metastore (`superset_meta`)
- Já vem configurado para:
  - Criar um administrador padrão no Docker-Compose.yaml (`admin / admin`)
  - Instalar o driver PostgreSQL (`psycopg2-binary`)
  - Executar o servidor de aplicação na porta `8088`

---

## Pré-Requisitos

Antes de iniciar, instale:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
---

## Configuração do Ambiente

1. Clone o Repositório.
   ```
   git clone git@github.com:Mateushqms/Desafio-T-cnico.git
   ```
2. Crie o arquivo `.env` a partir do exemplo `.env.example`:

2. Suba o ambiente com o Docker Compose:
    ```
    docker-compose up -d
    ```
## Testando as Conexões

### Airflow → Postgres

1. Acesse o Airflow: [http://localhost:8080](http://localhost:8080)
2. Faça login:
   - Usuário: `airflow` configuradas no .env em `_AIRFLOW_WWW_USER_USERNAME`.
   - Senha: `airflow` configuradas no .env em `_AIRFLOW_WWW_USER_PASSWORD`.
3. Vá em **Admin → Connections**
4. Clique no `+` "Add a new record"
5. Preencha:
   - Connection id: `postgres_default`
   - Connection type: `Postgres`
   - Host: `postgres`
   - Database: `analytics`
   - Login: valor de `POSTGRES_USER_AIRFLOW` no `.env`
   - Senha: valor de `POSTGRES_PASSWORD_AIRFLOW` no `.env`
   - Port: `5432`
6. Clique em **Test**
7. Uma mensagem de sucesso confirmará a interoperabilidade **Airflow → Postgres**
![](/evidencias/test_airflow1.png)
### Ou 

1. Acesse o Airflow: [http://localhost:8080](http://localhost:8080)
2. Faça login:
   - Usuário: `airflow`
   - Senha: `airflow`
3. Vá na DAG teste_postgres
4. Clique no botão de Play para triggar a DAG e verifique se deu sucesso.
5. Veja os logs em Graph -> teste_conexao_postgres -> logs.
![](/evidencias/test_airflow.png)

---

### Superset → Postgres

1. Acesse o Superset: [http://localhost:8088](http://localhost:8088)
2. Faça login:
   - Usuário: `admin`
   - Senha: `admin`
3. Vá em **+ → Data → Connect Database → PostgreSQL**
4. Preencha os campos:
   - Host: `postgres`
   - Port: `5432`
   - Database: `analytics`
   - Login/Senha: valores definidos no `.env` em `POSTGRES_USER_ANALYTICS` e `POSTGRES_PASSWORD_ANALYTICS`

5. Clique em **Connect**
6. Se não der a mensagem "Connection Failed ..." e ir para uma próxima etapa, está funcionando, só clicar em finish.
![](/evidencias/test_superset1.png)

---

### Conexão via SuperSet via SQLAlchemy URI (opcional)

1. No Superset, selecione **Connect Database → PostgreSQL**
2. Clique em **“Connect this database with SQLAlchemy URI string instead”**
3. Informe a URI abaixo (substituindo as variáveis do `.env`):
4. postgresql+psycopg2://{POSTGRES_USER_ANALYTICS}:{POSTGRES_PASSWORD_ANALYTICS}@postgres:5432/{POSTGRES_DATABASE_ANALYTICS}

![](/evidencias/test_superset.png)