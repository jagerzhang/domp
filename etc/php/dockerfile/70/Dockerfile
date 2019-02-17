FROM centos:7.5.1804
MAINTAINER jager<im@zhang.ge>

RUN yum install -y epel-release  \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
    && yum install -y memcached php70w-fpm php70w-gd php70w-pecl-memcached php70w-pecl-memcache php70w-opcache php70w-mysql php70w-mbstring php70w-pecl-redis \
    && yum clean all \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

CMD ["php-fpm", "-F"]
