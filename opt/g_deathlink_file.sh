#!/bin/bash
#Desc: Cut Nginx Log and Create Death Chain File
#Author: ZhangGe
#Blog: https://zhang.ge/5038.html
#Date: 2015-05-03
 
#①、初始化变量：
#定义access日志存放路径
LOGS_PATH=/data/wwwlogs
 
#定义蜘蛛UA信息（默认是百度蜘蛛）
UA='+http://www.baidu.com/search/spider.html'
 
#定义网站域名（需要先给相应的网站以域名形式配置了nginx日志，比如zhang.ge.log）
DOMAIN=zhang.ge
 
#定义网站访问地址
website=https://$DOMAIN

#定义前一天日期
DATE=`date +%Y-%m-%d -d "1 day ago"`
 
#定义日志路径
logfile=/home/wwwlogs/zhang.ge_${DATE}.log
 
#定义死链文件存放路径
deathfile=/home/wwwroot/zhang.ge/death.txt
 
#②、Nginx日志切割
mv ${LOGS_PATH}/${DOMAIN}.log ${LOGS_PATH}/${DOMAIN}_${DATE}.log
kill -USR1 `ps axu | grep "nginx: master process" | grep -v grep | awk '{print $2}'`
#可选功能: 自动删除30天之前的日志，可自行修改保存时长。
cd ${LOGS_PATH}
find . -mtime +30 -name "*20[1-9][3-9]*" | xargs rm -f

#③、网站死链生成（百度专用）
#分析日志并保存死链数据
for url in `awk -v str="${UA}" '$9=="404" && $15~str {print $7}' ${logfile}`
do
        grep -q "$url" ${deathfile} || echo ${website}${url} >>${deathfile}
done