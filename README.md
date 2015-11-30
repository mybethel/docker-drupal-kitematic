# Drupal Docker container [![Build Status](https://travis-ci.org/mybethel/docker-drupal-kitematic.svg)](https://travis-ci.org/mybethel/docker-drupal-kitematic) [![](https://badge.imagelayers.io/ignigena/drupal-kitematic:latest.svg)](https://imagelayers.io/?images=ignigena/drupal-kitematic:latest 'Get your own badge on imagelayers.io')

Basic Drupal stack optimized for Kitematic with volume sharing enabled for the
docroot at `/var/www/html`. No database is included in this image. For long-term
scalability it is recommended that your database not run on the same host that
serves your web traffic. For development, use another Docker image for your
database and connect the two in Kitematic with environment variables.

The following tags are available:

* `latest`: Currently defaults to Drupal 7, will soon move to D8
* `7.x`: Drupal 7 running on PHP 5.6
* `8.x`: Drupal 8 running on PHP 5.6
* `edge`: Drupal 8 running on PHP 7

Drush along with the recommended PHP extensions are installed by default. The
exception to this is currently the `edge` tag does not include the Twig C
extension due to it currently not being compatible with PHP 7.

In addition, both GIT and a MySQL client are both installed on the image. This
was done as a convenience for development purposes and enables the use of Drush
features such as `sql-sync` that require this.
