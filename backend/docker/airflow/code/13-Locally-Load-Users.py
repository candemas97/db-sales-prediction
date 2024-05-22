from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

import pandas as pd
import sqlalchemy
import pymysql

import os
import dotenv

dotenv.load_dotenv()


def load_users_sql(
    SQL_USER: str, SQL_PASSWORD: str, SQL_HOST: str, SQL_PORT: str, SQL_DATABASE: str
) -> None:
    """Save users to SQL

    Args:
        SQL_USER (str): User to sign in SQL
        SQL_PASSWORD (str): Password to sign in SQL
        SQL_HOST (str): Host to sign in SQL
        SQL_PORT (str): Port to sign in SQL
        SQL_DATABASE (str): Database to use in SQL
    """
    # Leer datos que serán cargados
    data = pd.read_csv(
        f"{os.getcwd()}/data/vendedores_projecto_final_bases_de_datos.csv"
    )

    # Cadena de conexión utilizando pyodbc
    connection_string = (
        f"mysql://{SQL_USER}:{SQL_PASSWORD}@{SQL_HOST}:{SQL_PORT}/{SQL_DATABASE}"
    )

    print(connection_string)

    # Crear el motor de conexión
    engine = sqlalchemy.create_engine(connection_string)

    # Cargar a SQL Local
    data.to_sql("users", con=engine, if_exists="replace", index=False)
    print("Se ha cargado la información a MySQL")


# DAG creation and execution

"""
Create dag and set the schedule interval
"""
dag = DAG(
    "13-Locally-Load-User",
    description="DAG que entrena el modelo",
    start_date=datetime(2024, 5, 3, 0, 0, 00000),
    schedule_interval="@once",  # "@once",
    catchup=False,
)

"""
Task 1: Leer data guardada en MongoDB
"""
t1 = PythonOperator(
    task_id="load_users_sql",
    provide_context=True,
    python_callable=load_users_sql,
    op_kwargs={
        "SQL_USER": os.getenv("SQL_USER_L"),
        "SQL_PASSWORD": os.getenv("SQL_PASSWORD_L"),
        "SQL_HOST": os.getenv("SQL_HOST_L"),
        "SQL_PORT": os.getenv("SQL_PORT_L"),
        "SQL_DATABASE": os.getenv("SQL_DATABASE_L"),
    },
    dag=dag,
)

t1
