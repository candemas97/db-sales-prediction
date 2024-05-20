from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import pymongo
import pandas as pd

import os
import json
import dotenv


def cargar_valores_env() -> str:
    """Leer todas las variables secretas

    Returns:
        str: Retorna las variables secretas
    """

    dotenv.load_dotenv()
    USERNAME = os.getenv("MONGODB_USER")
    PASSWORD = os.getenv("MONGODB_PASSWORD")
    SERVER = os.getenv("MONGODB_SERVER")
    return USERNAME, PASSWORD, SERVER


def reset_opportunity_data(**context) -> None:
    """
    Borrar variables de MongoDB
    """

    USERNAME, PASSWORD, SERVER = context["task_instance"].xcom_pull(
        task_ids="cargar_valores_env"
    )

    # Conectar a la base de datos en MongoDB
    uri = f"mongodb+srv://{USERNAME}:{PASSWORD}@{SERVER}/?retryWrites=true&w=majority&appName={SERVER}"

    # Crear cliente y conectar al servidor
    client = MongoClient(uri, server_api=ServerApi("1"))

    # Enviar PING para conocer si hay conexión  exitosa
    try:
        client.admin.command("ping")
        print("Pinged your deployment. You successfully connected to MongoDB!")
    except Exception as e:
        print(e)

    # Conectarse a la base de datos
    db = client["final_project"]

    # Conectarse a la colección
    collection_oppty = db["opportunities"]
    # Borrar lo que se encuentra en la colección
    collection_oppty.delete_many({})

    # Se lee la data
    df_oportunidad = pd.read_csv(
        f"{os.getcwd()}/data/oportunidades_negocio_projecto_final_bases_de_datos.csv"
    )

    # Insertar datos del DataFrame a MongoDB
    ## Se pasa el DataFrame a diccionario dirigido por records
    records = df_oportunidad.to_dict("records")
    ## Se manda a MongoDB
    collection_oppty.insert_many(records)


def reset_user_data(**context) -> None:
    """
    Cargar valores originales
    """

    USERNAME, PASSWORD, SERVER = context["task_instance"].xcom_pull(
        task_ids="cargar_valores_env"
    )

    # Conectar a la base de datos en MongoDB
    uri = f"mongodb+srv://{USERNAME}:{PASSWORD}@{SERVER}/?retryWrites=true&w=majority"

    # Crear cliente y conectar al servidor
    client = MongoClient(uri, server_api=ServerApi("1"))

    # Enviar PING para conocer si hay conexión  exitosa
    try:
        client.admin.command("ping")
        print("Pinged your deployment. You successfully connected to MongoDB!")
    except Exception as e:
        print(e)

    # Conectarse a la base de datos
    db = client["final_project"]
    # Conectarse a la colección
    collection_users = db["users"]

    # Borrar lo que se encuentra en la colección
    collection_users.delete_many({})

    # Lectura de datos originales
    df_vendedores = pd.read_csv(
        f"{os.getcwd()}/data/vendedores_projecto_final_bases_de_datos.csv"
    )

    # Insertar datos del DataFrame a MongoDB}

    ## Se pasa el DataFrame a diccionario dirigido por records
    records = df_vendedores.to_dict("records")
    ## Se manda a MongoDB
    collection_users.insert_many(records)


# DAG creation and execution

"""
Crear dag e intervalo de ejecución
"""
dag = DAG(
    "00-reset-data-as-original",
    description="DAG que reinicia los datos como originalmente estaban",
    start_date=datetime(2024, 5, 3, 0, 0, 00000),
    schedule_interval="@once",
    catchup=False,
)

"""
Task 1: Leer valores .env
"""
t1 = PythonOperator(
    task_id="cargar_valores_env",
    provide_context=True,
    python_callable=cargar_valores_env,
    dag=dag,
)

"""
Task 2: Reset datos de oportunidades
"""
t2 = PythonOperator(
    task_id="reset_opportunity_data",
    provide_context=True,
    python_callable=reset_opportunity_data,
    dag=dag,
)

"""
Task 3: Reset datos de usuario
"""
t3 = PythonOperator(
    task_id="reset_user_data",
    provide_context=True,
    python_callable=reset_user_data,
    dag=dag,
)

t1 >> [t2, t3]
