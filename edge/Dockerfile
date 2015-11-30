FROM php:7.0-apache

# Apache configuration
RUN a2enmod rewrite
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Install the PHP extensions we need.
RUN apt-get update && apt-get install -y git libpng12-dev libjpeg-dev libpq-dev mariadb-client-core-10.0 \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip

# Adding custom PHP settings.
COPY php.ini /usr/local/etc/php/conf.d/drupal.ini

# Install uploadprogress extension.
RUN pecl install uploadprogress \
  && echo "extension=uploadprogress.so" >> /usr/local/etc/php/conf.d/uploadprogress.ini \
  && rm -vrf /tmp/pear

# Install Twig C extension.
# @blocked on PHP7 due to https://github.com/twigphp/Twig/issues/1695

# Install Drush using Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require drush/drush:dev-master
RUN ln -sf $HOME/.composer/vendor/bin/drush /usr/local/bin/drush
RUN drush --version

# Set user 1000 and group staff to www-data, enables write permission.
# https://github.com/boot2docker/boot2docker/issues/581#issuecomment-114804894
RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

WORKDIR /var/www/html

# Install Drupal
ENV DRUPAL_VERSION 8.0.0
RUN drush dl drupal-${DRUPAL_VERSION} -d --destination=".." --drupal-project-rename="$(basename `pwd`)" -y
RUN chown -R www-data:www-data .

VOLUME  ["/var/www/html"]
