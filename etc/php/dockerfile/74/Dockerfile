FROM php:7.4-fpm-alpine3.13
MAINTAINER jager<im@zhang.ge>

ENV TZ=Asia/Shanghai

# 安装基础依赖
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --update --no-cache \
    && apk add --no-cache autoconf cmake make gcc g++

# 安装WP通用依赖
RUN docker-php-ext-install opcache
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install exif

# 安装GD扩展
RUN apk add --update --no-cache libpng-dev jpeg-dev freetype-dev libjpeg-turbo-dev \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd 

# 安装imagick扩展
RUN apk add --update --no-cache imagemagick imagemagick-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# 安装zip扩展
RUN apk add --no-cache libzip-dev \
    && docker-php-ext-install zip

# 安装mbstring扩展
RUN apk add --update --no-cache oniguruma-dev \
    && docker-php-ext-install mbstring

# 安装redis扩展
RUN pecl install redis \
    && docker-php-ext-enable redis

CMD ["php-fpm", "-F"]
