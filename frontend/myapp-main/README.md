# myapp

# Aplicación de Predicción de Oportunidades Comerciales

Esta aplicación se desarrolla como parte del curso "Tópicos Avanzados de Bases de Datos" en la Pontificia Universidad Javeriana. La aplicación está diseñada para gestionar y predecir oportunidades comerciales capturando datos relevantes y validando el estado de las propuestas.

## Características

- **Autenticación de Usuarios**: Los usuarios pueden iniciar sesión utilizando su correo electrónico y contraseña a través de Firebase Authentication.
- **Captura de Datos**: Los usuarios pueden ingresar datos para un modelo de predicción de oportunidades comerciales, los cuales se guardan en una base de datos MongoDB.
- **Validación de Propuestas**: Los usuarios pueden validar el estado de una propuesta comercial ingresando su número. La validación se realiza contra una base de datos Redis.
- **Conexión a Internet**: La aplicación requiere una conexión activa a internet para funcionar correctamente.

## Pantallas

1. **Pantalla de Inicio de Sesión**
    - Permite a los usuarios iniciar sesión utilizando Firebase Authentication.
    - Los usuarios deben ingresar su correo electrónico y contraseña para acceder a la aplicación.
    - Para efecto de la prueba se debe usar el usuario morenoluis@javeriana.edu.co y la clave de ingreso será Admin123

2. **Pantalla de Captura de Datos**
    - Los usuarios pueden ingresar todos los detalles necesarios para una oportunidad comercial.
    - Los datos ingresados se guardan en una base de datos MongoDB.
    - Los campos incluyen código de cliente(debe empezar por CL-99999 y cinco digitos cualquiera), ACV, TCV, margen que son valores decimales, el resto son listas seleccionables, también se debe seleccionar una fecha que debe ir a más de un año.

3. **Pantalla de Validación de Propuestas**
    - Los usuarios pueden validar el estado de una propuesta ingresando el número de la propuesta (este número es el que se genera en la pantalla de captura de datos).
    - La aplicación se conecta a una base de datos Redis para verificar el estado del número de propuesta ingresado.

## Dependencias

- **Flutter**: La aplicación está construida utilizando el framework Flutter.
- **Firebase**: Utilizado para la autenticación de usuarios.
- **MongoDB**: Almacena datos de oportunidades comerciales.
- **Redis**: Utilizado para validar el estado de las propuestas.

## Cómo Empezar

### Prerrequisitos

- Asegúrate de tener Flutter instalado en tu máquina. Para instrucciones de instalación, visita la [documentación oficial de Flutter](https://flutter.dev/docs/get-started/install).
- Configura Firebase para tu aplicación Flutter. Sigue las instrucciones en la [documentación oficial de Firebase](https://firebase.google.com/docs/flutter/setup).
- Configura las bases de datos MongoDB y Redis. Asegúrate de que sean accesibles a través de internet.

### Instalación

1. **Instalar el apk**:
    - Instala el apk suministrado en cualquier dispositivo con sistema operativo Android

2. **Permisos**:
    - Acepta los permisos requiridos para la aplicación(si son solicitados).



## Uso

1. **Inicio de Sesión**: Inicia la aplicación e inicia sesión con tu correo electrónico y contraseña.
2. **Captura de Datos**: Navega a la pantalla de captura de datos e ingresa la información requerida para una oportunidad comercial. Guarda los datos.
3. **Validación de Propuestas**: Navega a la pantalla de validación de propuestas, ingresa el número de la propuesta y verifica su estado.

## Contribuyendo

¡Las contribuciones son bienvenidas! Por favor, haz un fork del repositorio y crea un pull request con tus cambios.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT.

## Agradecimientos

- Los desarrolladores de Flutter, Firebase, MongoDB y Redis por la implementación de este ejercicio acádemico.
