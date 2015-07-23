FROM php:5.5-apache

RUN a2enmod rewrite

# Install the PHP extensions we need.
RUN apt-get update && apt-get install -y git libpng12-dev libjpeg-dev libpq-dev \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install gd mbstring pdo_mysql pdo_pgsql

WORKDIR /var/www/html

VOLUME  ["/var/www/html"]

# Install uploadprogress extension.
RUN pecl install uploadprogress \
  && echo "extension=uploadprogress.so" >> /usr/local/etc/php/php.ini

# Install Drush using Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require drush/drush:~7.0.0@rc
RUN ln -sf $HOME/.composer/vendor/bin/drush /usr/local/bin/drush
RUN drush --version

# Set user 1000 and group staff to www-data, enables write permission.
# https://github.com/boot2docker/boot2docker/issues/581#issuecomment-114804894
RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

# Adding custom php settings.
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Adding APCU for faster php
RUN pecl install apcu-beta \
    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

# https://www.drupal.org/drupal-7.38-release-notes
ENV DRUPAL_VERSION 7.38
ENV DRUPAL_MD5 c18298c1a5aed32ddbdac605fdef7fce

RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
  && echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
  && tar -xz --strip-components=1 -f drupal.tar.gz \
  && rm drupal.tar.gz \
  && chown -R www-data:www-data sites
