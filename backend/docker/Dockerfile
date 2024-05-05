# Descargamos airflow con python 3.9
FROM apache/airflow:2.6.0-python3.9

# Instalamos dependencias
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip
RUN python3 -m pip install -r /tmp/requirements.txt