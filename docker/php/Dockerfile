FROM php:7.4-fpm

WORKDIR /app

RUN apt-get update \
    && apt-get install -y \
    libpq-dev \
    zlib1g-dev \
    libzip-dev \
    libpng-dev \
    zip \
    zlibc \
    cron \
    vim \
    wkhtmltopdf \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install \
        bcmath \
        opcache \
        zip \
        gd \
        pdo pdo_pgsql

RUN yes | pecl install apcu xdebug-2.9.8 \
        && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini \
        && echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/apcu.ini \
        && echo "opcache.memory_consumption=192" >> /usr/local/etc/php/conf.d/opcache.ini \
        && echo "opcache.interned_strings_buffer=16" >> /usr/local/etc/php/conf.d/opcache.ini \
        && echo "opcache.max_accelerated_files=25000" >> /usr/local/etc/php/conf.d/opcache.ini \
        && echo "opcache.revalidate_freq=600" >> /usr/local/etc/php/conf.d/opcache.ini \
        && echo "opcache.fast_shutdown=1" >> /usr/local/etc/php/conf.d/opcache.ini \
        && echo "opcache.enable_clfi=1" >> /usr/local/etc/php/conf.d/opcache.ini \
        && echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini

RUN apt-get update -y \
    && apt-get install -y libgmp-dev re2c libmhash-dev wkhtmltopdf libmcrypt-dev file libmagickwand-dev --no-install-recommends \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ \
    && docker-php-ext-configure gmp \
    && docker-php-ext-install gmp \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install imagick && docker-php-ext-enable imagick

COPY docker/php/config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/php/config/php.ini  /usr/local/etc/php/conf.d/app.ini

# Install composer
ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer

COPY docker/php/composer/composer_installer.sh /composer/

RUN /composer/composer_installer.sh && \
    rm /composer/composer_installer.sh && \
    composer --ansi --version --no-interaction

COPY composer.json composer.lock /app/
RUN composer validate --no-check-all --strict
RUN composer install --no-interaction --no-progress --no-ansi --no-autoloader --no-scripts --prefer-dist

RUN rm -rf /srv && ln -s /app/ /srv && \
    chown www-data:www-data /app && \
    echo "www-data ALL=NOPASSWD: /usr/sbin/cron" >>/etc/sudoers

CMD ["bash", "bin/boot"]

COPY --chown=www-data . .
RUN composer dump-autoload --optimize --apcu

#USER www-data
