#!/bin/bash
# remove old version only for centos
yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine

# add repo and install latest version only for centos
yum-config-manager --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

# start and register to startup
service docker start
chkconfig docker on
# =========================================================
# install docker-compose only foy linux
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

# build php-fpm
docker build -t "php-fpm:7.2" ./

# start service
docker-compose up -d
