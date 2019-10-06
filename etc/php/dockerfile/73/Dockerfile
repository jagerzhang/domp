FROM centos:7.5.1804
MAINTAINER jager<im@zhang.ge>

RUN yum install -y epel-release  \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
    && yum install -y memcached php73w-fpm php73w-gd php73w-pecl-memcached php73w-pecl-memcache php73w-opcache php73w-mysql php73w-mbstring php73w-pecl-redis \
    && yum clean all \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    
CMD ["php-fpm", "-F"]
