# Extending the php apache image.
FROM php:7.1-apache

RUN a2enmod rewrite headers;

RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -

RUN apt-get -yqq update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        apt-utils \
        sqlite3 \
        libsqlite3-dev \
        libzip-dev \
        libpng-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    ;


# Install some updates php extensions.
RUN docker-php-ext-install \
    pdo_sqlite \
    mysqli \
    pdo_mysql \
    mcrypt \
    ;


RUN pecl install xdebug-2.5.0 \
    && pecl install zip \
    && docker-php-ext-enable xdebug zip \
    ;

COPY composer.phar /usr/local/bin/composer

COPY vhost.conf /etc/apache2/sites-enabled/000-default.conf
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY index.php /app/public/

# Change the default directory.
# It is specified as /var/www/html in the base image.
WORKDIR /app