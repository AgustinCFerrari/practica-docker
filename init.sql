CREATE DATABASE IF NOT EXISTS practica;
USE practica;
CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);
INSERT INTO usuarios (nombre) VALUES ('Arias Diego'), ('Godoy Sergio'), ('Ferrari Agustin');
