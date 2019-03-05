#!/bin/bash

## 备份配置信息 ##
# 存放空间
OSS_BUCKET="<YOUR_OSS_BUCKET_NAME>"
# 备份名称，用于标记
BACKUP_NAME="mysql-test-backup"
# Mysql 主机地址
MYSQL_SERVER="localhost"
# Mysql 用户名
MYSQL_USER="root"
# Mysql 密码
MYSQL_PASS="123456"
# Mysql 备份数据库，多个请空格分隔
MYSQL_DBS="db1 db2"
# 备份目录
BACKUP_SRC="/home/mysql-backup"
# 备份文件临时存放目录，一般不需要更改
BACKUP_TMP_DIR="/tmp/mysql-backup"
## 备份配置信息 End ##

## Start ##
NOW=$(date +"%Y%m%d%H%M%S")  # 精确到秒，同一秒内上传的文件会被覆盖
BACKUP_TMP_DIR=$BACKUP_TMP_DIR/$NOW

mkdir -p $BACKUP_TMP_DIR
mkdir -p $BACKUP_SRC

# 备份Mysql
echo "start dump mysql"
for db_name in $MYSQL_DBS
do
    echo 'dump db:' $db_name 
    file_name=${BACKUP_TMP_DIR}/${db_name}_bak.${NOW}.sql.gz
    echo 'dump file' $file_name 
	mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS $db_name | gzip > $file_name
done
echo "dump done"

# 打包
echo "start tar"
BACKUP_FILENAME="$BACKUP_NAME-$NOW.tar.gz"
tar -czvf $BACKUP_SRC/$BACKUP_FILENAME $BACKUP_TMP_DIR/*.sql.gz
echo "tar file $BACKUP_SRC/$BACKUP_FILENAME"
echo "tar done"

# 上传(上传文件依赖ossutil)
echo "start upload"
ossutil64 cp $BACKUP_SRC/$BACKUP_FILENAME oss://$OSS_BUCKET/$BACKUP_NAME/$BACKUP_FILENAME
echo "upload done"

# 清理备份文件
rm -rf $BACKUP_TMP_DIR
echo "backup clean done"

# todo清理历史备份文件