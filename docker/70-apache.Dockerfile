FROM alpine:3.7

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/phpearth/docker-php.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="PHP.earth" \
      org.label-schema.name="docker-php" \
      org.label-schema.description="Docker For PHP Developers - Docker image with PHP 7.0, Apache, and Alpine" \
      org.label-schema.url="https://github.com/phpearth/docker-php"

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /etc/php/7.0

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Persistent runtime dependencies
ARG DEPS="\
        php7.0 \
        php7.0-phar \
        php7.0-bcmath \
        php7.0-calendar \
        php7.0-mbstring \
        php7.0-intl \
        php7.0-mysqli \
        php7.0-pdo_mysql \
        php7.0-pdo_pgsql \
        php7.0-pgsql \
        php7.0-redis \
        php7.0-soap \
        php7.0-xsl \
        php7.0-memcached \
        php7.0-gd \
        php7.0-ldap \
        php7.0-exif \
        php7.0-ftp \
        php7.0-openssl \
        php7.0-zip \
        php7.0-sysvsem \
        php7.0-sysvshm \
        php7.0-sysvmsg \
        php7.0-shmop \
        php7.0-sockets \
        php7.0-zlib \
        php7.0-bz2 \
        php7.0-curl \
        php7.0-simplexml \
        php7.0-xml \
        php7.0-opcache \
        php7.0-dom \
        php7.0-xmlreader \
        php7.0-xmlwriter \
        php7.0-tokenizer \
        php7.0-ctype \
        php7.0-session \
        php7.0-fileinfo \
        php7.0-iconv \
        php7.0-json \
        php7.0-posix \
        php7.0-apache2 \
        php7.0-mongodb \
        curl \
        ca-certificates \
        runit \
        apache2 \
"

# PHP.earth Alpine repository for better developer experience
ADD https://repos.php.earth/alpine/phpearth.rsa.pub /etc/apk/keys/phpearth.rsa.pub

RUN set -x \
    && echo "https://repos.php.earth/alpine/v3.7" >> /etc/apk/repositories \
    && apk add --no-cache $DEPS \
    && mkdir -p /run/apache2 \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

COPY ./docker/tags/apache /

EXPOSE 80

CMD ["/sbin/runit-wrapper"]