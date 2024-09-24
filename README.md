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
   git clone git@github.com:usuario/repo.git
   cd repo
