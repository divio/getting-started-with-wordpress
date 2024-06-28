FROM composer:latest as builder

WORKDIR /app
COPY composer.* /app/
RUN composer install --no-interaction --no-dev --no-scripts

FROM wordpress:latest

WORKDIR /var/www/html
RUN apt-get update -y && apt-get install -y openssl zip unzip git

# install composer
COPY --from=builder /usr/bin/composer /usr/bin/composer

# install wordpress cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# copy required files
COPY --from=builder /app/vendor/ /var/www/html/vendor/
COPY --from=builder /app/wordpress/ /var/www/html/
COPY ./src/ /var/www/html/

EXPOSE 80

CMD ["apache2-foreground"]
