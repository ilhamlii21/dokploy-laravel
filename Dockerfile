FROM laravelsail/php80-composer:latest

WORKDIR /var/www/html

COPY . .

# Buat .env dari .env.example kalau belum ada
RUN cp .env.example .env

RUN composer install --no-dev --optimize-autoloader

# Install supervisor lewat pip (hindari masalah repo Debian EOL)
RUN pip3 install supervisor

# Buat config utama supervisor yang include semua file di conf.d
RUN mkdir -p /etc/supervisor/conf.d \
    && echo "[include]\nfiles = /etc/supervisor/conf.d/*.conf" > /etc/supervisord.conf

COPY docker/php.ini /etc/php/8.0/cli/conf.d/99-custom.ini
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/start-container /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container \
    && chmod -R ugo+rw /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

ENTRYPOINT ["start-container"]