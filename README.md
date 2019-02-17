# domp
## 基于Docker快速部署openresty + php-fpm + MySQL，并且支持开启redis动、静态缓存支持。

### 一、环境要求
理论上可以基于任何支持docker的平台，不过domp内置的一些脚本是基于centos 7编写，所以如果是非centos 7系统，不可以通过脚本快速部署，可以先手工安装docker，在参考`init.sh`脚本来完成部署。

### 二、目录及文件说明（必读）：
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
│   └── php-fpm.d
│       └── php-fpm.conf   # php-fpm 配置
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

### 二、快速拉起domp环境
#### 1、 修改克隆代码
```
mkdir -p /data && cd /data
git clone https://github.com/jagerzhang/domp.git
```
#### 2、修改MySQL root密码
```
vim docker-compose.yml
找到：
- "MYSQL_ROOT_PASSWORD=yourpassword"
将 yourpassword 改成自定义密码
```
#### 3、启动domp
```
bash init.sh
```
### 三、配置网站
