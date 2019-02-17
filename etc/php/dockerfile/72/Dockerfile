FROM centos:7.5.1804
MAINTAINER jager<im@zhang.ge>

RUN yum install -y epel-release  \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
    && yum install -y memcached php72w-fpm php72w-gd php72w-pecl-memcached php72w-pecl-memcache php72w-opcache php72w-mysql php72w-mbstring php72w-pecl-redis \
    && yum clean all \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    
COPY reload_php.sh /

CMD ["php-fpm", "-F"]
