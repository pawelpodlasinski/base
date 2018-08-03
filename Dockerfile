FROM php:7.2-fpm-alpine

RUN addgroup -g 1000 www && \
    adduser -D -u 1000 -G www -h /var/www www

RUN apk add --no-cache bash vim git \
    openssl \
    libcurl curl curl-dev

RUN docker-php-ext-install sockets && \
    docker-php-ext-install json && \
    docker-php-ext-install ctype && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install curl && \
    docker-php-ext-install bcmath

COPY --chown=www:www config/ /tmp/

RUN mv /tmp/php.ini /usr/local/etc/php/ && \
    mv /tmp/www.conf /usr/local/etc/php-fpm.d/ && \
    mv /tmp/test.sh /test.sh && \
    chmod +x /test.sh && \
    rm -rf /tmp/* /var/www/html/ && \
    chown -R www:www /usr/local/etc/php

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#COPY --chown=www:www . /data
USER www
WORKDIR /data
#RUN composer install

HEALTHCHECK --interval=10s --timeout=3s \
    CMD \
    SCRIPT_NAME=/ping \
    SCRIPT_FILENAME=/ping \
    REQUEST_METHOD=GET \
    cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1

EXPOSE 9000

STOPSIGNAL SIGQUIT

CMD ["php-fpm"]
