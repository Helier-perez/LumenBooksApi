FROM php:8.1-fpm-buster 

RUN apt-get update && apt-get install -qqy git unzip libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libaio1 wget && apt-get clean autoclean && apt-get autoremove --yes &&  rm -rf /var/lib/{apt,dpkg,cache,log}/

# PHP extensions
RUN docker-php-ext-install sockets
RUN docker-php-ext-install soap
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

#composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Xdebug
RUN pecl install xdebug-3.1.1 \
&& docker-php-ext-enable xdebug

COPY ./docker/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./docker/php/conf.d/error_reporting.ini /usr/local/etc/php/conf.d/error_reporting.ini  

WORKDIR /var/www  

EXPOSE 9000