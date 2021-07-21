FROM alpine:3.14
LABEL Maintainer="EdyTheCow"
LABEL Description="Lightweight container with Nginx & PHP based on Alpine Linux"

# Install packages and remove default server definition
RUN apk --no-cache add \
  curl \
  nginx \
  php7 \
  php7-ctype \
  php7-curl \
  php7-dom \
  php7-fpm \
  php7-gd \
  php7-intl \
  php7-json \
  php7-mbstring \
  php7-mysqli \
  php7-opcache \
  php7-openssl \
  php7-phar \
  php7-session \
  php7-xml \
  php7-xmlreader \
  php7-zlib \
  supervisor \
# WHMCS ----
  php7-common \
  php7-bcmath \
  php7-enchant \
  php7-xmlrpc \
  php7-zip \
  php7-bz2 \
  # php7.4-imap \ --- not needed?
  php-pear \
  php-imagick \
  php-igbinary \
  php-redis

# Create symlink so programs depending on `php` still function
RUN ln -s /usr/bin/php7 /usr/bin/php

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html
COPY --chown=nobody src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
