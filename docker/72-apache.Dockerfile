FROM alpine:3.9

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/phpearth/docker-php.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="PHP.earth" \
      org.label-schema.name="docker-php" \
      org.label-schema.description="Docker For PHP Developers - Docker image with PHP 7.2, Apache, and Alpine" \
      org.label-schema.url="https://github.com/phpearth/docker-php"

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /etc/php/7.2

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Persistent runtime dependencies
ARG DEPS="\
        php7.2 \
        php7.2-phar \
        php7.2-bcmath \
        php7.2-calendar \
        php7.2-mbstring \
        php7.2-intl \
        php7.2-mysqli \
        php7.2-pdo_mysql \
        php7.2-pdo_pgsql \
        php7.2-pgsql \
        php7.2-redis \
        php7.2-soap \
        php7.2-xsl \
        php7.2-memcached \
        php7.2-gd \
        php7.2-ldap \
        php7.2-exif \
        php7.2-ftp \
        php7.2-openssl \
        php7.2-zip \
        php7.2-sysvsem \
        php7.2-sysvshm \
        php7.2-sysvmsg \
        php7.2-shmop \
        php7.2-sockets \
        php7.2-zlib \
        php7.2-bz2 \
        php7.2-curl \
        php7.2-simplexml \
        php7.2-xml \
        php7.2-opcache \
        php7.2-dom \
        php7.2-xmlreader \
        php7.2-xmlwriter \
        php7.2-tokenizer \
        php7.2-ctype \
        php7.2-session \
        php7.2-fileinfo \
        php7.2-iconv \
        php7.2-json \
        php7.2-posix \
        php7.2-apache2 \
        php7.2-mongodb \
        curl \
        ca-certificates \
        runit \
        apache2 \
"

# PHP.earth Alpine repository for better developer experience
ADD https://repos.php.earth/alpine/phpearth.rsa.pub /etc/apk/keys/phpearth.rsa.pub

RUN set -x \
    && echo "https://repos.php.earth/alpine/v3.9" >> /etc/apk/repositories \
    && apk add --no-cache $DEPS \
    && mkdir -p /run/apache2 \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

COPY ./docker/tags/apache /

EXPOSE 80

CMD ["/sbin/runit-wrapper"]