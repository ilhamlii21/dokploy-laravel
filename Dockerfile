FROM laravelsail/php80-composer:latest

WORKDIR /var/www/html

COPY . .

# Buat .env dari .env.example kalau belum ada
RUN cp .env.example .env

RUN composer install --no-dev --optimize-autoloader

# Install supervisor yang belum ada di base image
RUN sed -i 's|deb.debian.org/debian-security|archive.debian.org/debian-security|g; s|deb.debian.org/debian|archive.debian.org/debian|g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends supervisor \
    && rm -rf /var/lib/apt/lists/*

COPY docker/php.ini /etc/php/8.0/cli/conf.d/99-custom.ini
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/start-container /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container \
    && chmod -R ugo+rw /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

ENTRYPOINT ["start-container"]