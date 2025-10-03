# Imagen base oficial de PHP con Apache
FROM php:8.2-apache

# Instalamos extensión mysqli para conectarnos a MySQL
RUN docker-php-ext-install mysqli

# Definimos directorio de trabajo
WORKDIR /var/www/html

# Copiamos el código PHP dentro de la imagen
COPY src/ ./

# Exponemos el puerto interno 80
EXPOSE 80
