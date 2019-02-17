FROM centos:7.5.1804
MAINTAINER jager<im@zhang.ge>

RUN yum install -y epel-release  \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
    && yum install -y memcached php56w-fpm php56w-gd php56w-pecl-memcached php56w-pecl-memcache php56w-opcache php56w-mysql php56w-mbstring php56w-pecl-redis \
    && yum clean all \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

CMD ["php-fpm", "-F"]
