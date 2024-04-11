FROM wordpress:latest

WORKDIR /var/www/html

RUN apt-get update -y && apt-get install -y openssl zip unzip git
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY . /var/www/html
# RUN composer install --prefer-dist
