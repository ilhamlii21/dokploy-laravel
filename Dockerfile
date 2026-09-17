FROM laravelsail/php80-composer:latest

WORKDIR /var/www/html

COPY . .

RUN cp .env.example .env

RUN composer install --no-dev --optimize-autoloader

COPY docker/php.ini /etc/php/8.0/cli/conf.d/99-custom.ini
COPY docker/start-container /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container \
    && chmod -R ugo+rw /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

ENTRYPOINT ["start-container"]