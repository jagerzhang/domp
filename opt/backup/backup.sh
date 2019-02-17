#!/bin/sh
###################################################################
#  Web Backup version 1.0.0 Author: Jager <im@zhang.ge>        #
# For more information please visit https://zhang.ge/5117.html #
#-----------------------------------------------------------------#
#  Copyright ©2016 zhang.ge. All rights reserved.              #
###################################################################

isDel=n
args=$#
isDel=${!args}
# 设置压缩包解压密码
mypassword=123456

test -f /etc/profile && . /etc/profile >/dev/null 2>&1
baseDir=$(cd $(dirname $0) && pwd)
zip --version >/dev/null || yum install -y zip
ZIP=$(which zip)
TODAY=`date +%u`
MYSQLDUMP=$(which mysqldump)

# 基于coscmd的上传备份文件函数
uploadToCOS()
{
    file=$2
    domain=$1
    file_name=$(basename $2)
    coscmd upload $file $domain/$file_name
    if [[ $? -eq 0 ]] &&  [[ "$isDel" == "y" ]]
    then
        test -f $2 && rm -f $2
    fi
}

printHelp()
{
clear
printf '
=====================================Help infomation=========================================
1. Use For Backup database:
The $1 must be [db]
    $2: [domain]
    $3: [dbname]
    $4: [mysqluser]
    $5: [mysqlpassword]
    $6: [back_path]
    $7: [isDel]

For example:./backup.sh db zhang.ge zhangge_db zhangge 123456 /home/wwwbackup/zhang.ge

2. Use For Backup webfile:
The $1 must be [file]:
    $2: [domain]
    $3: [site_path]
    $4: [back_path]
    $5: [isDel]

For example:./backup.sh file zhang.ge /home/wwwroot/zhang.ge /home/wwwbackup/zhang.ge
=====================================End of Hlep==============================================

'
exit 0
}

backupDB()
{
    domain=$1
    dbname=$2
    mysqluser=$3
    mysqlpd=$4
    back_path=$5
    test -d $back_path || (mkdir -p $back_path || echo "$back_path not found! Please CheckOut Or feedback to zhang.ge..." && exit 2)
    cd $back_path
    #如果是要备份远程MySQL，则修改如下语句中localhost为远程MySQL地址
    $MYSQLDUMP -hlocalhost -u$mysqluser -p$mysqlpd $dbname --skip-lock-tables --default-character-set=utf8 >$back_path/$domain\_db_$TODAY\.sql
    test -f $back_path/$domain\_db_$TODAY\.sql || (echo "MysqlDump failed! Please CheckOut Or feedback to zhang.ge..." && exit 2)
    $ZIP -P$mypassword -m $back_path/$domain\_db_$TODAY\.zip $domain\_db_$TODAY\.sql && \
    uploadToCOS $domain $back_path/$domain\_db_$TODAY\.zip
}

backupFile()
{
    domain=$1
    site_path=$2
    back_path=$3
    test -d $site_path || (echo "$site_path not found! Please CheckOut Or feedback to zhang.ge..." && exit 2)
    test -d $back_path || (mkdir -p $back_path || echo "$back_path not found! Please CheckOut Or feedback to zhang.ge..." && exit 2)
    test -f $back_path/$domain\_$TODAY\.zip && rm -f $back_path/$domain\_$TODAY\.zip
    $ZIP -P$mypassword -9r $back_path/$domain\_$TODAY\.zip $site_path && \
    uploadToCOS $domain $back_path/$domain\_$TODAY\.zip    
}

while [ $1 ]; do
    case $1 in
        '--db' | 'db' )
        backupDB $2 $3 $4 $5 $6
        exit
        ;;
        '--file' | 'file' )
        backupFile $2 $3 $4
        exit  
        ;;
        * )
        printHelp
        exit
        ;;
    esac
done
printHelp
