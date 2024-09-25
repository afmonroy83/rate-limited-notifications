# Notificaciones Rails App

Este es un sistema de notificaciones construido en Rails que incluye un servicio de cola de trabajo en segundo plano utilizando **Sidekiq** y **Redis**. El sistema permite enviar diferentes tipos de notificaciones a los usuarios, aplicando límites de tasa para evitar sobrecargar a los destinatarios con demasiados correos electrónicos.

## Tecnologías utilizadas

- **Rails** 7.x
- **PostgreSQL** (con soporte para PostGIS)
- **Redis** (para manejar las colas de Sidekiq)
- **Sidekiq** (para procesamiento de trabajos en segundo plano)
- **Docker** (para la contenedorización del entorno de desarrollo)

## Configuración del proyecto

### Prerrequisitos

Asegúrate de tener instalados los siguientes componentes en tu máquina:

- **Docker** y **Docker Compose**

### Pasos para levantar el proyecto

1. **Clonar el repositorio**

   Clona este repositorio en tu máquina local:

   ```bash
   git clone https://github.com/afmonroy83/rate-limited-notifications.git
   cd rate-limited-notifications
2. **Crear y levantar los contenedores con Docker Compose**
   Ejecuta el siguiente comando para construir y levantar todos los servicios (base de datos, Redis, web, y Sidekiq):
      ```bash
      docker-compose up --build
      ```
   Esto levantará la aplicación Rails, la base de datos PostgreSQL, el servidor Redis y el servicio de Sidekiq.

3. **Configurar la base de datos**
   Abre una nueva terminal y corre las migraciones para la base de datos:
   ```bash
      docker compose exec web bash
      bundle exec rails db:migrate
   ```
   Esto creará y migrará la base de datos dentro del contenedor de Docker.
4. **Inicia sidekiq**
    Abre una nueva terminal para iniciar sidekiq:
   ```bash
      docker compose exec web bash
      bundle exec rails sidekiq
   ```
      
     
5. **Acceder a la aplicación**
   La aplicación estará disponible en tu navegador en `http://localhost:3000` corriendo el siguiente comando:
   ```bash
      docker compose exec web bash
      bundle exec rails server --port=3000 --binding="0.0.0.0"
   ```
6. ** Herramientas para testear **

   * Enviar una notificacion tipo **status**:
      ```
         curl -X POST http://localhost:3000/notifications -H "Content-Type: application/json" -d '{"type":"status", "user_id":"user@example.com", "message":"account status"}'
      ```
   * Enviar una notificacion tipo **news**:
      ```
      curl -X POST http://localhost:3000/notifications -H "Content-Type: application/json" -d '{"type":"news", "user_id":"user@example.com", "message":"you have news!"}'
      ```
   * Enviar una notificacion tipo **marketing**:
      ```
      curl -X POST http://localhost:3000/notifications -H "Content-Type: application/json" -d '{"type":"marketing", "user_id":"user@example.com", "message":"the clickbait is here!"}'
      ```
   * Ejemplo de una solicitud invalida:
      ```
      curl -X POST http://localhost:3000/notifications \
        -H "Content-Type: application/json" \
        -d '{"notification": {"type": "invalid_type", "user_id": "user@example.com", "message": "Test message"}}'
      ```
   

## Servicios
El proyecto incluye los siguientes servicios principales:

- **Web**: Aplicación Rails que maneja las notificaciones.
- **Sidekiq**: Procesador de trabajos en segundo plano para manejar las colas de notificaciones.
- **Redis**: Almacén de datos en memoria que Sidekiq utiliza para manejar las colas.
- **PostgreSQL**: Base de datos relacional que almacena la información de la aplicación.

## Panel de Sidekiq
Si quieres monitorear los trabajos en cola de Sidekiq, puedes acceder al panel de Sidekiq en `http://localhost:3000/sidekiq.`
## Variables de entorno

Las siguientes variables de entorno son necesarias para configurar la conexión con los servicios:

- `DB_USERNAME`: Nombre de usuario de la base de datos (por defecto: `postgres`).
- `DB_PASSWORD`: Contraseña de la base de datos (por defecto: `12345`).
- `DB_NAME`: Nombre de la base de datos (por defecto: `notifications`).
- `DB_HOST`: Host de la base de datos (por defecto: `db`).
- `REDIS_SERVER`: URL del servidor Redis (por defecto: `redis://redis:6379`).
- 
Estas variables ya están configuradas en el archivo docker-compose.yml.

##  Como correr los tests
Para correr las pruebas del proyecto, usa el siguiente comando dentro del contenedor web:

1. Abre una nueva terminal.
2. Ejecuta el siguiente comando para correr las pruebas:
   ```bash
      docker compose exec web bash
      bundle exec rspec
      ```
Esto ejecutará todas las pruebas unitarias y de integración que están configuradas para el proyecto. Las pruebas están escritas utilizando el framework RSpec.

### Migrar la base de datos de pruebas

Asegúrate de que la base de datos de pruebas está correctamente configurada antes de correr los tests:

   ```bash
      docker compose exec web bash
      bundle exec rails db:migrate
   ```

## Problemas comunes
* **Sidekiq no arranca**: Asegúrate de que Redis está corriendo correctamente. Verifica el contenedor de Redis con `docker-compose ps`.
* **Error al conectar con la base de datos**: Verifica que las variables de entorno de la base de datos en el archivo `docker-compose.yml` coinciden con la configuración de tu proyecto.

