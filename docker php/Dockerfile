FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

COPY . /var/www/html

WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000