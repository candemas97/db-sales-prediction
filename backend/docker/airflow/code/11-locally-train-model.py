from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import pymongo
import pandas as pd

import os
import dotenv
import json

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import make_column_transformer  # for dummies
from sklearn.pipeline import Pipeline  # creating a pipeline
from sklearn.model_selection import GridSearchCV

from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

import joblib

dotenv.load_dotenv()


def read_data_local(USERNAME: str, PASSWORD: str, SERVER: str) -> json:
    """Función que lee los datos

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


def train_model_local(**context) -> None:
    """
    Entrena el modelo
    """
    # Tomar la data del paso anterior
    data = context["task_instance"].xcom_pull(task_ids="read_data_local")
    df = pd.read_json(data, orient="records")

    # Solo tomar los que ya acabaron
    df = df[df["etapas"].isin(["Lost", "Won"])]

    # Division X y
    y = df["etapas"]
    X = df.drop(columns="etapas")

    # (80% train, 20% test)
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.20, random_state=42
    )

    # Dummificar

    categorical_columns = X_train.select_dtypes(exclude=[int, float]).columns
    column_trans = make_column_transformer(
        (OneHotEncoder(handle_unknown="ignore"), categorical_columns),
        remainder="passthrough",
    )

    # Escalar
    pipe = Pipeline(
        steps=[
            ("column_trans", column_trans),
            ("scaler", StandardScaler(with_mean=False)),
            ("RandomForestClassifier", RandomForestClassifier()),
        ]
    )

    # Búsqueda hiperparámetros
    param_grid = dict()
    param_grid["RandomForestClassifier__max_depth"] = [1, 2, 3, 10]
    param_grid["RandomForestClassifier__n_estimators"] = [10, 11]

    search = GridSearchCV(pipe, param_grid, cv=10, n_jobs=2)

    # Entrenamiento
    search.fit(X_train, y_train)

    # Tomar el mejor modelo y grabar
    best_estimator = search.best_estimator_
    best_params = search.best_params_
    print(f"\n\n\nLos mejores hiperparámetros fueron: {best_params}\n\n\n")

    ############ OJO ##################

    joblib.dump(best_estimator, f"{os.getcwd()}/model/ml_model.joblib")
    # joblib.dump(best_estimator, f"../model/ml_model.joblib")

    # Verificar calidad de la solución
    y_pred = best_estimator.predict(X_test)
    print(
        f"\n\n\nModel has an accuracy of {accuracy_score(y_test,y_pred)} in test\n\n\n"
    )


# DAG creation and execution

"""
Create dag and set the schedule interval
"""
dag = DAG(
    "11-Locally-Train-Model",
    description="DAG que entrena el modelo",
    start_date=datetime(2024, 5, 3, 0, 0, 00000),
    schedule_interval="@once",
    catchup=False,
)

"""
Task 1: Leer data guardada
"""
t1 = PythonOperator(
    task_id="read_data_local",
    provide_context=True,
    python_callable=read_data_local,
    op_kwargs={
        "USERNAME": os.getenv("MONGODB_USER_L"),
        "PASSWORD": os.getenv("MONGODB_PASSWORD_L"),
        "SERVER": os.getenv("MONGODB_SERVER_L"),
    },
    dag=dag,
)

"""
Task 2: Entrenar modelo
"""
t2 = PythonOperator(
    task_id="train_model_local",
    provide_context=True,
    python_callable=train_model_local,
    dag=dag,
)

t1 >> t2
