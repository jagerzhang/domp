FROM centos:7.5.1804
MAINTAINER jager<im@zhang.ge>

RUN yum install -y epel-release  \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
    && yum install -y memcached php71w-fpm php71w-gd php71w-pecl-memcached php71w-pecl-memcache php71w-opcache php71w-mysql php71w-mbstring php71w-pecl-redis \
    && yum clean all \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    
COPY reload_php.sh /

CMD ["php-fpm", "-F"]
