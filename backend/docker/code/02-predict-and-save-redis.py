from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import pymongo

import redis
import socket
from redis.commands.json.path import Path
from redis import exceptions
from redis.commands.json.decoders import unstring, decode_list

import os
import dotenv

dotenv.load_dotenv()

import pandas as pd
import json

import joblib


def read_data_mongodb(USERNAME: str, PASSWORD: str, SERVER: str) -> json:
    """Función que lee los datos de MongoDB

    Args:
        USERNAME (str): Usuario de la base de datos
        PASSWORD (str): Contraseña de la base de datos
        SERVER (str): Servidor de la base de datos

    Returns:
        json: Datos finales
    """

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
    collection_oppty = db["opportunities"]

    # Leer datos excluyendo el campo '_id'
    documents = collection_oppty.find(
        {},
        {
            "_id": 0,
            "numero_opportunidad": 1,
            "unidad_negocio": 1,
            "etapas": 1,
            "tipos": 1,
            "acv": 1,
            "tcv": 1,
            "margen_ganancia": 1,
            "regiones": 1,
            "territorios": 1,
            "industrias": 1,
            "edad_oferta": 1,
            "lead_source": 1,
        },
    )

    # Convertir a DataFrame
    df = pd.DataFrame(list(documents))

    return df.to_json(orient="records")


def predict_win_or_loose(**context) -> json:
    """Predecir si se ganará o se perderá

    Returns:
        json: Datos predicción
    """
    # Tomar la data del paso anterior
    data = context["task_instance"].xcom_pull(task_ids="read_data_mongodb")
    df = pd.read_json(data, orient="records")

    # Leer modelo guardado
    model = joblib.load("./model/ml_model.joblib")

    # Predecir si se ganará o se perderá
    y_pred = model.predict(df.drop(columns=["etapas", "numero_opportunidad"]))

    # Transformar solución a cargar a Redis (Numero Oppty y Predicción)
    df_resul = pd.concat([df["numero_opportunidad"], pd.DataFrame(y_pred)], axis=1)
    df_resul.columns = ["numero_opportunidad", "prediccion_modelo"]

    return df_resul.to_json(orient="records")


def save_data_redis(
    REDIS_HOST: str, REDIS_PORT: int, REDIS_PASSWORD: str, **context
) -> None:
    """
    Graba datos en redis
    """
    # Tomar la data del paso anterior
    data = context["task_instance"].xcom_pull(task_ids="predict_win_or_loose")
    df_resul = pd.read_json(data, orient="records")
    df_resul.set_index("numero_opportunidad", inplace=True)
    diccionario_resul = df_resul.to_dict()

    # Conectarse a Redis
    r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PASSWORD)

    # Borrar los valores dentro de la base de datos
    r.flushdb()

    # Crear un pipeline
    pipeline = r.pipeline()

    # Añadir cada par clave-valor al pipeline
    for clave, valor in diccionario_resul["prediccion_modelo"].items():
        pipeline.set(clave, valor)

    # Ejecutar todos los comandos en el pipeline de una vez (cargar todo a Redis)
    pipeline.execute()

    # Verify values were loaded
    valor = r.get("OP-00000")
    print(f"First elemnt that is key=OP-00000 has their value as {valor}")


# DAG creation and execution

"""
Create dag and set the schedule interval
"""
dag = DAG(
    "02-Predict-And-Save-Redis",
    description="DAG que entrena el modelo",
    start_date=datetime(2024, 5, 3, 0, 0, 00000),
    schedule_interval="* * * * *",  # "@once",
    catchup=False,
)

"""
Task 1: Leer data guardada en MongoDB
"""
t1 = PythonOperator(
    task_id="read_data_mongodb",
    provide_context=True,
    python_callable=read_data_mongodb,
    op_kwargs={
        "USERNAME": os.getenv("MONGODB_USER"),
        "PASSWORD": os.getenv("MONGODB_PASSWORD"),
        "SERVER": os.getenv("MONGODB_SERVER"),
    },
    dag=dag,
)

"""
Task 2: Predecir si se gana o pierde
"""
t2 = PythonOperator(
    task_id="predict_win_or_loose",
    provide_context=True,
    python_callable=predict_win_or_loose,
    dag=dag,
)

"""
Task 3: Guardar datos de predicción en Redis
"""
t3 = PythonOperator(
    task_id="save_data_redis",
    provide_context=True,
    python_callable=save_data_redis,
    op_kwargs={
        "REDIS_HOST": os.getenv("REDIS_HOST"),
        "REDIS_PORT": int(os.getenv("REDIS_PORT")),
        "REDIS_PASSWORD": os.getenv("REDIS_PASSWORD"),
    },
    dag=dag,
)

t1 >> t2 >> t3
