FROM php:7.3-fpm

RUN apt update \
    && apt install -y nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Adding our services to the S6 expected location
COPY resources/docker/services.d /etc/services.d

# Adding the S6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

# Copy the application files to run correct location
COPY --chown=www-data:www-data . /var/www/html

WORKDIR /var/www/html

# Enable the site for Nginx
ADD resources/docker/default.conf /etc/nginx/sites-enabled/default

EXPOSE 80 443

ENTRYPOINT ["/init"]
