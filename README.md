# Bases de Datos para la predicción de ventas

## 1. Introducción 

### Descripción del Proyecto 

Este proyecto implica el desarrollo de una arquitectura funcional que integra el uso de tres tipos de bases de datos, tanto relacionales como no relacionales, un modelo de machine learning, y un panel de visualización de datos. La finalidad de esta arquitectura es facilitar la captura de oportunidades de venta de una multinacional estadounidense de comunicaciones, a través de una interfaz de usuario diseñada para que los vendedores ingresen información relevante sobre oportunidades de negocio. Esta información capturada es almacenada en las bases de datos y utilizada para alimentar el modelo de machine learning encargado de realizar predicciones sobre dichas oportunidades de negocio identificadas, es decir, si se ganan o se pierden. 

 
### Contexto 

En el contexto de la predicción de ventas, identificar oportunidades de venta y almacenar estos datos es crucial. Las bases de datos no relacionales juegan un papel esencial en este proceso debido a su flexibilidad y escalabilidad, características que son importantes vitales para manejar grandes volúmenes de datos desestructurados o semi-estructurados generados por las interacciones de los vendedores en la interfaz de usuario. Al guardar esta información en bases de datos no relacionales, las empresas pueden capturar y analizar una amplia gama de datos de ventas en tiempo real, desde notas de interacciones hasta detalles específicos de las oportunidades de venta. Esta riqueza de datos permite alimentar con precisión los modelos de machine learning, mejorando significativamente la capacidad de prever tendencias de ventas futuras y facilitando decisiones estratégicas más informadas y oportunas. 

 

### Alcance 

El alcance de este proyecto académico es diseñar y desarrollar una arquitectura funcional que integre múltiples tecnologías, incluyendo bases de datos relacionales y no relacionales, un modelo de machine learning y herramientas de visualización de datos. Este proyecto se presentará en funcionamiento, mostrando la capacidad de la arquitectura para procesar y analizar datos en tiempo real, proporcionando insights valiosos y predicciones precisas. Cabe destacar que no se espera replicar, expandir ni llevar este proyecto a producción, ya que su propósito es netamente académico. Se busca que esta aplicación evidencie el dominio técnico de las herramientas y conceptos aprendidos en el curso y que ilustre el potencial práctico de estas tecnologías en escenarios comerciales simulados. 

## 2. Objetivos 

### Objetivo General 

Desarrollar una aplicación que integre tecnologías de bases de datos, machine learning y visualización de datos para analizar y predecir si las oportunidades de ventas se ganan o pierden, utilizando datos dummies de una compañía. 

### Objetivos Específicos 

Implementar y configurar tres tipos de bases de datos (relacionales, no relacionales) para gestionar eficientemente los datos recolectados a través de la interfaz de usuario, asegurando una base sólida y confiable para el análisis y la predicción. 

Desarrollar y entrenar un modelo de machine learning que utilice los datos almacenados para generar predicciones precisas sobre el resultado final de las oportunidades de venta, y presentar estos resultados a través de un panel de visualización de datos que facilite la interpretación. 

## 3. Atributos de Calidad 

**Escalabilidad:** La arquitectura del proyecto está diseñada para ser escalable, permitiendo el manejo de un mayor volumen de datos y usuarios sin comprometer el rendimiento. Utilizando MongoDB Atlas para la base de datos documental y Redis para la caché, se facilita la escalabilidad horizontal. Además, los servicios desplegados en Docker pueden ser escalados fácilmente al añadir más contenedores. 

**Rendimiento:** El proyecto emplea Redis como una caché de alta velocidad para almacenar las predicciones del modelo, lo que mejora significativamente el tiempo de respuesta. Python se utiliza para el procesamiento ETL y la ejecución del modelo, aprovechando bibliotecas optimizadas para manejar grandes volúmenes de datos de manera eficiente. 

**Disponibilidad:** La disponibilidad del sistema se asegura mediante el uso de servicios en la nube como MongoDB Atlas y el despliegue en contenedores Docker, que ofrecen alta disponibilidad y redundancia. Los datos críticos se almacenan en bases de datos SQL para reporting, garantizando que siempre haya acceso a los datos importantes. 

**Seguridad:** La seguridad se implementa a través de prácticas recomendadas de manejo de datos y autenticación segura en todas las interacciones del sistema. Las bases de datos y servicios como MongoDB Atlas, y Redis incluyen medidas de seguridad robustas como cifrado de datos y autenticación. 

**Mantenibilidad:** El uso de Docker facilita la mantenibilidad al permitir el despliegue de entornos consistentes y aislados. Los scripts en Python están bien documentados y estructurados, lo que facilita la actualización y modificación del código. El uso de Power BI para la visualización permite una fácil actualización de informes sin cambios significativos en el backend. 

**Confiabilidad:** La confiabilidad del sistema se asegura mediante el uso de bases de datos robustas como PostgreSQL y MongoDB Atlas, así como el almacenamiento en caché con Redis. Las pruebas exhaustivas del modelo predictivo en Python aseguran que las predicciones sean precisas y confiables. La integración de todas las partes del sistema se realiza de manera que cualquier falla sea rápidamente identificada y corregida. 


## 4. Descripción de la Arquitectura 

### Diagrama de Arquitectura 

La arquitectura mostrada en la imagen es un sistema integrado para la recolección, procesamiento y visualización de datos, diseñado para manejar y analizar información de oportunidades de negocio.  

![Arquitectura](/backend/images/arq.png)


### Componentes 

**Front Entrada (Flutter):** Es la interfaz de usuario desarrollada con Flutter, donde se ingresan los datos de posibles negociaciones. Esta interfaz es el punto de entrada para los datos que serán procesados y analizados. 

**BD JSON - MongoDB Atlas:** Los datos ingresados a través de la interfaz de usuario son almacenados en MongoDB Atlas, una base de datos NoSQL que utiliza un formato JSON documental. Esta base de datos se encarga de manejar los datos desestructurados de la empresa. 

**Modelo (Python):** Un modelo de machine learning ejecutado en Python que realiza procesos ETL (Extract, Transform, Load) y predicciones. Este modelo toma los datos de MongoDB, los procesa y genera predicciones. 

**BD SQL:** Los datos procesados y las predicciones generadas por el modelo en Python son almacenados en una base de datos SQL, que es utilizada para operaciones de reporting y análisis estructurado. 

**Dashboard (Power BI):** Un panel de control que muestra estadísticas generales y resultados obtenidos del modelo de predicción. Este dashboard facilita la visualización y el análisis de los datos. 

**BD Redis:** Actúa como un caché para las predicciones del modelo. Al ser una base de datos en memoria que ofrece alta velocidad en el acceso a datos, permite almacenar y recuperar rápidamente las predicciones que son consultadas frecuentemente por el sistema o los usuarios. 

## Flujo de Datos 

Los datos fluyen principalmente desde la interfaz de usuario hacia MongoDB, luego hacia el modelo en Python, y finalmente a la base de datos SQL y el dashboard. Redis interactúa directamente con el modelo para almacenar y proporcionar acceso rápido a las predicciones. Además, existe un flujo directo entre el front de entrada y Redis para actualizar o recuperar predicciones de manera eficiente.

- Las siguientes son las estructuras de datos que recibe MongoDB desde la interfaz de usuario, dichas estructuras están en formato JSON. 

![JSON](/backend/images/json.png)

- El modelo hala la información de estas estructuras almacenadas en MongoDB para realizar el entrenamiento y predicción del resultado de las oportunidades de venta. El modelo es un Random Forest, al que se le aplica una búsqueda de hiperparámetros para encontrar la combinación más eficiente, iterando el número de árboles y la profundidad de estos.
- El resultado del modelo se guarda junto a las variables iniciales en la base de datos de SQL Server y es enviada al Redis que funciona como caché.
- La base de datos de SQL es leída desde Power BI junto con la base de datos de los vendedores, que también fue guardada allí, dichas bases siempre van a contener las mismas columnas. A continuación, se muestra el diagrama de entidad relación visualizado en Power BI.

![PB](/backend/images/pb.png)

Por último, se muestra el tablero construido:

![Dashboard](/backend/images/dashboard.png)

## 5. Tecnologías Utilizadas

### Lenguajes de Programación

Para el proyecto, se utilizaron dos lenguajes de programación clave. Python se empleó para leer y colocar información en las diferentes bases de datos, así como para el desarrollo del modelo de predicción, se aprovechó la versatilidad de sus bibliotecas para la manipulación de datos, la interacción con bases de datos como MongoDB, Redis y SQL, y la implementación de algoritmos de aprendizaje automático. Por otro lado, el lenguaje utilizado para la aplicación de la interfaz de usuario fue Dart, mediante el framework Flutter. Esta combinación permitió una integración fluida entre el backend de datos, el modelo predictivo y una interfaz de usuario intuitiva y eficiente.
Frameworks y Librerías
Para el proyecto, se emplearon diferentes librerías de Python:
- Pymongo (4.7.1): Utilizada para interactuar con bases de datos NoSQL de MongoDB, facilitando operaciones de lectura y escritura.
- Redis (5.0.1): Empleada para gestionar una base de datos en memoria, proporcionando una capa de caché rápida y fiable.
- SQLAlchemy (1.4.48): Usada para la manipulación de bases de datos SQL, ofreciendo una interfaz ORM que simplifica las operaciones de consulta y manipulación de datos.
- Pyodbc (5.1.0): Utilizada para establecer conexiones con bases de datos a través de ODBC, se asegura la compatibilidad con una amplia gama de sistemas de gestión de bases de datos.
- Python-dotenv (1.0.1): Para manejar variables de entorno de manera segura, esencial para la configuración de la aplicación.
- Pandas (2.0.1): Usada para la manipulación y análisis de datos, proporcionando estructuras de datos flexibles y eficientes.
- Scikit-learn (1.3.0): Utilizada para implementar algoritmos de aprendizaje automático, permitiendo la creación de modelos predictivos robustos y precisos.

### Plataformas y Servicios

En el desarrollo del proyecto, se emplearon diversas plataformas y servicios. Apache Airflow se utilizó para halar la información guardada en MongoDB (archivo JSON), y entrenamiento del modelo de machine learning. Docker permitió la creación de entornos de desarrollo y producción consistentes y aislados, asegurando que todas las dependencias y configuraciones fueran replicables. SQL Server se usó como base de datos relacional para el almacenamiento estructurado de datos, mientras que MongoDB sirvió como base de datos NoSQL para datos más flexibles y no estructurados. Redis se utilizó como sistema de almacenamiento en caché, mejorando significativamente la velocidad de acceso a datos frecuentemente consultados. Para el desarrollo de la interfaz de usuario, se empleó Flutter, para tener una experiencia de usuario atractiva y responsiva. Además, Python y bibliotecas como Pandas y Scikit-learn se usaron para la manipulación de datos y la implementación del modelo de predicción. Para la visualización y análisis de los datos, se utilizó Power BI, que permitió crear un informe interactivo para facilitar la toma de decisiones.

## 6. Configuración e Instalación

### Requisitos Previos
**Sistema operativo:**
- Linux (recomendado) o macOS
- Windows (posible, pero puede requerir pasos adicionales)
**Hardware:**
- CPU: Al menos 4 núcleos
- RAM: 8 GB mínimo (16 GB o más recomendado)
- Dispositivo móvil con sistema operativo Android superior a 8 para la aplicación realizada en flutter.
- Almacenamiento: Espacio suficiente para los datos y modelos
**Software:**
- Python (versión 3.9 o superior)
- Docker y Docker Compose
- Git (para control de versiones)

### Instrucciones de Instalación

Para poder ejecutar este proyecto se ha generado un `README` tanto para el `backend` como para el `frontend`.

El orden en el cual debe ser ejecutado este proyecto para evitar incnvenientes es:

1. Correr todo el `backend`
2. Correr todo el `frontend`

## 7. Uso del Proyecto

Para las indicaciones de como usar el proyecto dirigirse a los `README` Del `backend` y el `frontend`.

## 8. Pruebas y Validación

### Estrategia de Pruebas
1.	**Pruebas unitarias:** se realizan pruebas unitarias en cada componente de la arquitectura, garantizando el correcto funcionamiento individual de cada componente, se probará el código del modelo de machine learning, se incluirá las funciones de interfaz de usuario .
2.	**Pruebas de integración:**  Se llevará la prueba de integración entre cada uno de los componentes de la arquitectura, esto incluye interfaz de usuario y los modelos de machine learning, se probará la comunicación con las bases de datos (sqlserver)- radis –mongodb, se revisará la consistencia de los datos 
3.	**Pruebas del sistema:**  Se realizarán pruebas de sistema para evaluar el funcionamiento general de la arquitectura como un todo. Esto implica probar todas las funcionalidades de extremo a extremo, desde la captura de datos por parte de los vendedores hasta la presentación de las predicciones de ventas en el panel de visualización de datos.
4.	**Pruebas de rendimiento:** Se llevarán a cabo pruebas de rendimiento para evaluar la capacidad de la arquitectura para manejar grandes volúmenes de datos y procesar predicciones de manera eficiente. 

### Casos de Prueba
- **Pruebas de bases de datos:** verificar el funcionamiento adecuado de las bases de datos relacionales (SQL Server) y no relaciones (redis-mongodb), conexión- retorno de datos-almacenamiento de información.
- **Modelo Machine Learning:** 
    - Revisar que el modelo se pueda entrenar correctamente con los datos almacenados.
    - Validar la precisión de la predicción de ventas del modelo.
- **Pruebas de integración**
    - Validar la comunicación entre interfaz de usuario y las bases de datos.
    - Revisar la integración del modelo con las bases de datos.
- **Pruebas de interfaz de usuario**
    - Revisar que la aplicación permita correctamente una autenticación, validando una base datos no relacional.
    - Revisar que el vendedor pueda recolectar información relevante sobre oportunidades de negocio. 
    - Validar que el sistema en tiempo real almacene esta información en las bases de datos. 

### Resultados Esperados
- **Pruebas Unitarias:**  Todas las funciones individuales pasan las pruebas unitarias sin errores.
- **Pruebas de Integración:** La comunicación entre los componentes de la arquitectura se realiza correctamente.  La integración del modelo de machine learning con los datos almacenados es exitosa.
- **Pruebas de Sistema:** Todas las funcionalidades de extremo a extremo funcionan como se esperaba. La presentación de predicciones de ventas en el panel de visualización de datos es precisa y eficiente.
- **Pruebas de Rendimiento:** Validar carga de datos sin degradación del rendimiento.

## 9. Mantenimiento y Soporte

### Guia de Mantenimiento
- Si se libera en un ambiente productivo, se tendría que revisar periódicamente las bibliotecas utilizadas (versionamiento) en el desarrollo para garantizar la seguridad en la aplicación. 
- Mantener un sistema de log en el servidor para hacer seguimiento y evitar un comportamiento no esperado de la aplicación.
- Aplicar un sistema de backups del sistema (base de datos y aplicar versionamiento de la aplicación)

### Soporte
Proporcionar documentación detallada sobre la arquitectura del sistema, incluyendo diagramas de flujo, diagramas de base de datos, y descripciones de componentes clave. Esto ayudará a los desarrolladores y administradores a comprender el funcionamiento del sistema y resolver problemas de manera más eficiente.


## 10. Contribuciones
### Guía de Contribución
- **Reportar Problemas (Issues):**
    - Si encuentras errores, comportamientos inesperados o tienes sugerencias de mejora, por favor, abre un nuevo issue en nuestro repositorio.
    - Describe el problema de forma clara y concisa, incluyendo pasos para reproducirlo si es posible.
- **Mejorar la Documentación:**
    - Puedes corregir errores tipográficos, añadir explicaciones más detalladas o crear nuevos tutoriales.
- **Desarrollar Nuevas Funcionalidades:**
    - Antes de empezar a trabajar en ella, abre un issue para discutirla con el equipo. Una vez que se apruebe tu propuesta, puedes crear un fork del repositorio, implementar la funcionalidad y enviar un pull request.
- **Corregir Errores (Bugs):**
    - Crea un fork del repositorio, corrige el error y envía un PR con tus cambios.

### Políticas de Código
Todos los cambios deben ser revisados mediante pull requests y aprobados por al menos un revisor antes de fusionarse. Se espera que los contribuyentes escriban pruebas unitarias para nuevas funcionalidades o correcciones de errores. Estas políticas aseguran que el proyecto mantenga una base de código de alta calidad y evolucione de manera organizada.

## 11. Licencia
El código es distribuido bajo la licencia Eclipse Public License - v 2.0. La cuál es declarada en su idioma original en el Anexo 1.
## 12. Agradecimientos
Se agradece la realización del proyecto a sus autores:
- Yudy Tatiana Pedraza Torres
- Carlos Andrés Másmela Pinilla
- Fabian Madero Araque
- Giovanny Albarracín
- Elkin Sánchez
