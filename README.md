# Docker PHP-FPM 7.4 & Nginx 1.20 on Alpine Linux

* Built on the lightweight and secure Alpine Linux distribution
* Very small Docker image size (+/-40MB)
* Uses PHP 8.0 for better performance, lower CPU usage & memory footprint
* Optimized for 100 concurrent users
* Optimized to only use resources when there's traffic (by using PHP-FPM's on-demand PM)
* The servers Nginx, PHP-FPM and supervisord run under a non-privileged user (nobody) to make it more secure
* The logs of all the services are redirected to the output of the Docker container (visible with `docker logs -f <container name>`)
* Follows the KISS principle (Keep It Simple, Stupid) to make it easy to understand and adjust the image to your needs

## Usage

Start the Docker container:

    docker run -p 80:8080 trafex/php-nginx

See the PHP info on http://localhost, or the static html page on http://localhost/test.html

Or mount your own code to be served by PHP-FPM & Nginx

    docker run -p 80:8080 -v ~/my-codebase:/var/www/html trafex/php-nginx

## Configuration
In [config/](config/) you'll find the default configuration files for Nginx, PHP and PHP-FPM.
If you want to extend or customize that you can do so by mounting a configuration file in the correct folder;

Nginx configuration:

    docker run -v "`pwd`/nginx-server.conf:/etc/nginx/conf.d/server.conf" trafex/php-nginx

PHP configuration:

    docker run -v "`pwd`/php-setting.ini:/etc/php7/conf.d/settings.ini" trafex/php-nginx

PHP-FPM configuration:

    docker run -v "`pwd`/php-fpm-settings.conf:/etc/php7/php-fpm.d/server.conf" trafex/php-nginx

_Note; Because `-v` requires an absolute path I've added `pwd` in the example to return the absolute path to the current directory_
