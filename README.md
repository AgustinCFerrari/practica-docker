# Práctica Formativa II – Dockerización de Proyecto Web

Grupo 15
Comisión D

Arias Diego
Godoy Sergio
Ferrari Agustín

Este repositorio contiene el proyecto de la **Práctica Formativa Obligatoria N°2**, donde se dockeriza una aplicación web simple con servicios de **MySQL**, **Nginx** y **PHP+Apache**.  

## 🔹 Estructura del proyecto

```
practica-docker/
├─ docker-compose.yml      # Orquestación de contenedores
├─ Dockerfile              # Imagen personalizada para PHP+Apache
├─ src/                    # Código PHP dinámico
│  └─ index.php
├─ web/                    # Archivos estáticos servidos por Nginx
│  └─ index.html
└─ init.sql                # Script de inicialización de MySQL
```

## 🔹 Servicios incluidos

- **dbserver (MySQL 8)**  
  - Base de datos `practica`.  
  - Usuario root con contraseña `admin`.  
  - Tabla `usuarios` precargada con 3 registros ('Arias Diego', 'Godoy Sergio', 'Ferrari Agustin').  
  - Puerto expuesto: `3307`.

- **webserver (Nginx)**  
  - Sirve archivos estáticos desde `web/`.  
  - Puerto expuesto: `8080`.

- **practicaweb (PHP+Apache)**  
  - Ejecuta el código PHP desde `src/`.  
  - Se conecta a la base `practica` en `dbserver`.  
  - Puerto expuesto: `8081`.

## 🔹 Requisitos previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado.  
- Docker Compose v2 (ya viene incluido con Docker Desktop).  
- Red externa creada (si no existe):  

```bash
docker network create mynet
```

## 🔹 Cómo ejecutar

1. Clonar este repositorio:
   ```bash
   cd practica-docker
   git init
   git remote add origin https://github.com/AgustinCFerrari/practica-docker.git
   
   ```

2. Levantar los contenedores:
   ```bash
   docker compose up -d --build
   ```

3. Verificar que todo esté corriendo:
   ```bash
   docker compose ps
   ```

## 🔹 Acceso a los servicios

- 🌐 **Web estática (Nginx):** [http://localhost:8080](http://localhost:8080)  
- 🐘 **App PHP (Apache+PHP):** [http://localhost:8081](http://localhost:8081)  
- 🗄️ **Base de datos (MySQL Workbench):**  
  - Host: `127.0.0.1`  
  - Port: `3307`  
  - User: `root`  
  - Pass: `admin`  

## 🔹 Archivos principales

### `src/index.php`
```php
<?php
$mysqli = new mysqli("dbserver", "root", "admin", "practica");
if ($mysqli->connect_error) {
  die("Conexión fallida: " . $mysqli->connect_error);
}

$result = $mysqli->query("SELECT id, nombre FROM usuarios");

echo "<h1>Usuarios</h1>";
while ($row = $result->fetch_assoc()) {
  echo $row['id'] . " - " . htmlspecialchars($row['nombre']) . "<br>";
}
```

### `init.sql`
```sql
CREATE DATABASE IF NOT EXISTS practica;
USE practica;
CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);
INSERT INTO usuarios (nombre) VALUES ('Arias Diego'), ('Godoy Sergio'), ('Ferrari Agustin');
```

## 🔹 Comandos útiles

- Ver logs en vivo:
  ```bash
  docker compose logs -f practicaweb
  docker compose logs -f dbserver
  ```

- Entrar a la base de datos:
  ```bash
  docker exec -it dbserver mysql -uroot -padmin practica
  ```

- Reiniciar stack:
  ```bash
  docker compose down
  docker compose up -d --build
  ```

- Limpiar todo (incluye datos de MySQL):
  ```bash
  docker compose down -v
  ```

## 🔹 Problemas y soluciones comunes

- **Error 403 Forbidden en Apache** → faltaban permisos. Se soluciona con:
  ```bash
  docker exec -it practicaweb bash -c "chown -R www-data:www-data /var/www/html && chmod -R a+rX /var/www/html"
  ```
- **Puerto 3306 ocupado** → cambiar en `docker-compose.yml`:
  ```yaml
  ports:
    - "3307:3306"
  ```
  Y conectarse en Workbench a `127.0.0.1:3307`.

- **Error de tabla inexistente** → volver a ejecutar `init.sql`:
  ```bash
  docker exec -i dbserver mysql -uroot -padmin < init.sql
  ```

## 🔹 Imagen pública en Docker Hub

- **Docker (MySQL + PHP/Apache + Nginx estático)**

Este proyecto levanta un entorno completo con **tres servicios**:

1. **MySQL 8** (base de datos)  
2. **App PHP** (Apache) publicada en Docker Hub: `agustin62/practica-docker-practicaweb`  
3. **Nginx estático** publicado en Docker Hub: `agustin62/practica-docker-webstatic`  

El objetivo es que cualquier persona pueda reproducir la práctica **sin archivos locales extra** y con **un único comando**.

---

- **Requisitos**

- Docker Desktop (incluye Docker Compose v2)
- Conexión a Internet (para descargar imágenes)
- Puertos libres: `8080`, `8081` y **preferentemente** `3307` (o `3306`)

---

- **Levantar el entorno**

Ubicarse en la carpeta que contenga `docker-compose.yml` y ejecutá:

```bash
docker compose down -v   # borra contenedores + volumen (datos)
docker compose up -d

```
## 🔹 Enlaces de los repositorios 

https://github.com/AgustinCFerrari/practica-docker

https://hub.docker.com/repositories/agustin62?search=docker



