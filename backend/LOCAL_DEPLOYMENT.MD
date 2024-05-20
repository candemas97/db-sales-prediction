# Despliegue local

## Requisitos

Para correr la arquitectura localmente debe tener instalado docker y docker compose

````
docker >= 26.0.0
docker compose >= v2.25.0
````

Para correr toda la arquitectura de manera local siga los siguientes pasos


- 1. copiar las variables de entorno `.env-local` a un archivo `.env` en la raiz del directorio `./backend`
- 2. correr el siguiente comando `docker compose -f docker-compose-db.yaml -f docker-compose.yaml up --build`
- 3. si quiere correr el pipeline de la etl siga las instrucciones del readme 
- 4. Para predecir si una nueva oportunidad es favorable o no, por favor agregar el nuevo registro al mongodb con el formato que se presenta a continuación y correr el pipeline en airflow

`````
{
  "numero_opportunidad": "OP-00000",
  "cliente": "CL-01169",
  "unidad_negocio": "BU-05",
  "etapas": "Lost",
  "tipos": "TY-04",
  "acv": 476458.92,
  "tcv": 943194.18,
  "margen_ganancia": 0.06,
  "regiones": "RE-02",
  "territorios": "TE-15",
  "industrias": "IN-23",
  "fecha_creacion_oportunidad": "2021-08-17",
  "fecha_cierre_oportunidad": "2022-02-06",
  "edad_oferta": 173,
  "lead_source": "LS-06",
  "numero_vendedor": "NV-4"
}

`````

- 5. Una vez haya corrido el pipeline, ingresar a la db de redis y revisar el resultado de la oportunidad

