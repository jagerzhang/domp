### 一、简单介绍
domp是`Docker+Openresty+php-fpm+MySQL`环境的首字母缩写，可以基于Docker快速部署`Openresty + php-fpm + MySQL`，并且支持开启redis动、静态缓存优化。

domp用到的Docker镜像全部来自`hub.docker.com`的官方镜像，其中php-fpm因为各网站需求的模块各异，所以单独抽出来自定义编译，基于Dockerfile，过程透明，可完全自定义。

通过domp来部署一个php网站环境，不考虑国内网络因素，耗时不超过5分钟，而通过OneinStack或lnmp一键安装包少说也要40分钟甚至1小时以上，高下立判。目前张戈博客完全基于domp稳定运行半年有余，性能、稳定性、可运维性还是值得肯定的！

### 二、环境要求
理论上可以基于任何支持docker的平台，不过domp内置的一些脚本是基于centos 7编写，所以如果是非centos 7系统，不可以通过脚本快速部署，请参见下面的附录。

### 三、目录及文件说明（必读）：
```
[root@localhost]# tree
.
├── docker-compose.yml   # docker 编排配置
├── Dockerfile           # php-fpm docker镜像编译文件（可自定义）
├── etc                  # 配置目录
│   ├── nginx
│   │   ├── cert         # 证书一级SSL公共配置存放目录，若启用https，请将证书放到此目录
│   │   │   └── options-ssl-nginx.conf
│   │   └── conf.d           # nginx 配置目录
│   │       ├── common.conf  # nginx 公共配置
│   │       ├── ext          # nginx 拓展配置
│   │       │   ├── header.conf  # header 通用配置
│   │       │   ├── proxy.conf   # proxy 通用配置
│   │       │   └── ssl.conf     # ssl 跳转配置
│   │       └── vhost            # 虚拟主机配置（必须修改的配置），已放置2个参考实例配置，仅供参考：
│   │           ├── yourdomain.com_cache.conf  # 站点配置文件（带缓存），实际使用需要将yourdomain.com改成实际域名。
│   │           └── yourdomain.com.conf        # 站点配置文件（无缓存），实际使用需要将yourdomain.com改成实际域名。
│   └── php
│       ├── dockerfile  # php-fpm 镜像编译配置（已添加5.6、7.0-7.2版本编译文件）
│       │   ├── 56
│       │   │   └── Dockerfile
│       │   ├── 70
│       │   │   └── Dockerfile
│       │   ├── 71
│       │   │   └── Dockerfile
│       │   └── 72
│       │       └── Dockerfile
│       └── php-fpm.d
│           └── php-fpm.conf # php-fpm 配置
├── init.sh  # domp 初始化并启动的脚本
├── LICENSE
├── opt
│   ├── backup
│   │   └── backup.sh # 基于 腾讯云COS备份脚本，需要先安装并配置 coscmd，参考：https://cloud.tencent.com/document/product/436/10976
│   ├── g_cache.sh    # 基于 shell 的预缓存脚本，需要自行修改并添加定时任务，参考：https://zhang.ge/5095.html
│   └── g_deathlink_file.sh # 基于 shell 的死链生成脚本，需要自行修改并添加定时任务，参考：https://zhang.ge/5038.html
├── README.md
└── reload_php.sh  # php reload脚本，build镜像的时候回ADD到镜像里面。
```
### 四、快速拉起domp环境
#### 1、 克隆代码
```
mkdir -p /data && cd /data
git clone https://github.com/jagerzhang/domp.git
```
#### 2、修改MySQL root密码、指定php版本
```
vim docker-compose.yml
找到：
- "MYSQL_ROOT_PASSWORD=yourpassword"
将 yourpassword 改成自定义密码

找到：
build: ./etc/php/dockerfile/72/ 
将72改成需要的php版本，目前支持56、70、71、72 四个版本，若无版本刚需，使用默认的7.2即可！
```
Ps: 若因国内功夫墙导致php-fpm在线编译失败，可以如下修改：
```
vim docker-compose.yml
找到：
php-fpm:
    build: ./etc/php/dockerfile/72/
    container_name: php-fpm
    image: php-fpm:7.2
改为：
php-fpm:
    #build: ./etc/php/dockerfile/72/
    container_name: php-fpm
    image: jagerzhang/php-fpm:7.2 # 这里直接使用张戈做好的镜像即可，版本同样有 5.6，7.0-7.2。如果一定有特殊php模块需求则不能使用。
```
#### 3、自定义php模块
##### php5.6 ~ 7.2 参考以下内容操作
```
vim etc/php/dockerfile/72/Dockerfile

# 找到如下语句，若满足要求则无需修改，若缺少某模块，则加上 php72w-模块名称，pecl的可能要额外加上 pecl
yum install -y memcached php72w-fpm php72w-gd php72w-pecl-memcached php72w-opcache php72w-mysql php72w-mbstring php72w-pecl-redis
```
##### php7.3 ~ 7.4 参考以下内容操作
```
vim etc/php/dockerfile/74/Dockerfile

# 参考官方安装拓展的方法：使用内置命令 docker-php-ext-install / pecl install / docker-php-ext-enable 安装即可，请参考文档：https://hub.docker.com/_/php (How to install more PHP extensions)

```

#### 4、启动domp
```
bash init.sh

docker ps # 查看是否正常启动
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                                 NAMES
2fdcd10d05c6        openresty/openresty:centos   "/usr/bin/openresty …"   2 hours ago         Up 2 hours                                                openresty
eb5684527e4b        php-fpm:7.2                  "php-fpm -F"             2 hours ago         Up 2 hours                                                php-fpm
41381dea3d7f        redis:latest                 "docker-entrypoint.s…"   2 hours ago         Up 2 hours          127.0.0.1:6379->6379/tcp              redis
1f6278298539        mysql:8.0                    "docker-entrypoint.s…"   4 days ago          Up 4 days           127.0.0.1:3306->3306/tcp, 33060/tcp   mysql
```
### 五、配置网站

#### 1、虚拟主机配置说明
domp 默认已经自带了2种虚拟主机配置：`yourdomain.com.conf` 和 `yourdomain.com_cache.conf`，第一个不带`redis`缓存，第二个带`redis`缓存，自行选择一个，然后删除另一个即可。然后参考这个配置文件来定制自己网站的配置文件。若看不懂这个配置文件，可以直接拷贝网站原来的`vhost`配置文件也可以。

#### 2、https证书配置说明
https证书请放置到 `domp/etc/nginx/cert` 目录，然后在vhost配置中引用即可，注意在vhost里面的配置要变为：`/etc/nginx/cert/证书名字` ，而非`domp/etc/nginx/cert` 目录，因为已经挂载到了`docker`里面了！！！

#### 3、缓存配置说明
若开启了openresty+redis缓存，且正好又是wordpress网站，则可以安装下`nginx-hepler`和`Redis Object Cache`插件，天然绝配！后续有时间会有domp一系列的文章分享，敬请期待：https://zhang.ge/ 。

## 附录
### 非centos环境使用参考

1、安装docker，参考：https://docs.docker.com/install/

2、安装 docker-compose，参考：https://docs.docker.com/compose/install/

Ps：此处提供linux通用安装命令：
```
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
```
3、启动domp
```
docker-compose up -d
```
