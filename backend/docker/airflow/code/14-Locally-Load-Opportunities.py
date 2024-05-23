from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import pymongo

import sqlalchemy

import os
import dotenv

dotenv.load_dotenv()

import pandas as pd
import json

import joblib

def read_data_mongodb_local(USERNAME: str, PASSWORD: str, SERVER: str) -> json:
    """Función que lee los datos de MongoDB

    Args:
        USERNAME (str): Usuario de la base de datos
        PASSWORD (str): Contraseña de la base de datos
        SERVER (str): Servidor de la base de datos

    Returns:
        json: Datos finales
    """

    uri = f"mongodb://{USERNAME}:{PASSWORD}@{SERVER}/?retryWrites=true&w=majority"

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

    # Leer datos excluyendo el campo '_id'
    documents = collection_oppty.find(
        {},
        {
            "_id": 0,
        },
    )

    # Convertir a DataFrame
    df = pd.DataFrame(list(documents))

    return df.to_json(orient="records")


def predict_win_or_loose_local(**context) -> json:
    """Predecir si se ganará o se perderá

    Returns:
        json: Datos predicción
    """
    # Tomar la data del paso anterior
    data = context["task_instance"].xcom_pull(task_ids="read_data_mongodb_local")
    df = pd.read_json(data, orient="records")

    df = df[["numero_opportunidad",
            "unidad_negocio",
            "etapas",
            "tipos",
            "acv",
            "tcv",
            "margen_ganancia",
            "regiones",
            "territorios",
            "industrias",
            "edad_oferta",
            "lead_source",]]

    # Leer modelo guardado
    model = joblib.load(f"{os.getcwd()}/model/ml_model.joblib")

    # Predecir si se ganará o se perderá
    y_pred = model.predict(df.drop(columns=["etapas", "numero_opportunidad"]))

    # Transformar solución a cargar a Redis (Numero Oppty y Predicción)
    df_resul = pd.concat([df["numero_opportunidad"], pd.DataFrame(y_pred)], axis=1)
    df_resul.columns = ["numero_opportunidad", "prediccion_modelo"]

    return df_resul.to_json(orient="records")


def save_data_sql_server_local(
    SQL_USER: str, SQL_PASSWORD: str, SQL_HOST: str, SQL_PORT: str, SQL_DATABASE: str, **context
) -> None:
    """
    Graba datos en redis
    """
    # Tomar la data del paso anterior
    data_inicial = context["task_instance"].xcom_pull(task_ids="read_data_mongodb_local")
    data = context["task_instance"].xcom_pull(task_ids="predict_win_or_loose_local")

    df_resul = pd.read_json(data_inicial, orient="records")
    df_prediccion = pd.read_json(data, orient="records")
    df_prediccion=df_prediccion.drop(["numero_opportunidad"], axis=1)
    df_consolidado = pd.concat([df_resul, df_prediccion], axis=1).sort_values(by="numero_opportunidad")
    # Cadena de conexión utilizando pyodbc
    connection_string = f"mysql://{SQL_USER}:{SQL_PASSWORD}@{SQL_HOST}:{SQL_PORT}/{SQL_DATABASE}"

    # Crear el motor de conexión
    engine = sqlalchemy.create_engine(connection_string)

    # Oportunidad de ventas a SQL
    df_consolidado.to_sql('oportunidades', con=engine, if_exists='replace', index=False)

    return df_consolidado


# DAG creation and execution

"""
Create dag and set the schedule interval
"""
dag = DAG(
    "14-Locally-Load-Opportunity-MySQL",
    description="DAG que entrena el modelo",
    start_date=datetime(2024, 5, 3, 0, 0, 00000),
    schedule_interval="@once",  # "@once",
    catchup=False,
)

"""
Task 1: Leer data guardada en MongoDB
"""
t1 = PythonOperator(
    task_id="read_data_mongodb_local",
    provide_context=True,
    python_callable=read_data_mongodb_local,
    op_kwargs={
        "USERNAME": os.getenv("MONGODB_USER_L"),
        "PASSWORD": os.getenv("MONGODB_PASSWORD_L"),
        "SERVER": os.getenv("MONGODB_SERVER_L"),
    },
    dag=dag,
)

"""
Task 2: Predecir ganar o no
"""
t2 = PythonOperator(
    task_id="predict_win_or_loose_local",
    provide_context=True,
    python_callable=predict_win_or_loose_local,
    dag=dag,
)

"""
Task 3: Guardar en SQL
"""
t3 = PythonOperator(
    task_id="save_data_sql_server_local",
    provide_context=True,
    python_callable=save_data_sql_server_local,
    op_kwargs={
        "SQL_USER": os.getenv("SQL_USER_L"),
        "SQL_PASSWORD": os.getenv("SQL_PASSWORD_L"),
        "SQL_HOST": os.getenv("SQL_HOST_L"),
        "SQL_PORT": os.getenv("SQL_PORT_L"),
        "SQL_DATABASE": os.getenv("SQL_DATABASE_L"),
    },
    dag=dag,
)

t1 >> t2 >> t3 