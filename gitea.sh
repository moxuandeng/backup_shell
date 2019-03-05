#!/bin/bash

## 备份配置信息 ##
# 存放空间
OSS_BUCKET="<YOUR_OSS_BUCKET_NAME>"
# docker镜像名称
DOCKER_NAME='gitea'
# docker数据目录
DOCKER_DATA_PATH='/var/lib/gitea'
# 备份名称，用于标记
BACKUP_NAME="gitea-backup"
## 备份配置信息 End ##


NOW=$(date +"%Y%m%d%H%M%S")  # 精确到秒，同一秒内上传的文件会被覆盖

# 备份文件的路径
BACKUP_SRC=$DOCKER_DATA_PATH/gitea/dump

# 备份(/data/gitea/dump下的文件也会被打包进去，所以要记得删除)
echo "start dump"
docker exec -it --user git $(docker ps -qf "name="$DOCKER_NAME) sh -c 'mkdir -p /data/gitea/dump && cd /data/gitea/dump && gitea dump'
echo "dump done"

# dump出来的已经是压缩包 无需再打包
# 获取最后dump的文件
BACKUP_FILE=$(ls -lt $BACKUP_SRC/*.zip | head -1 | awk '{print $9}')

# oss上存储的文件名
OSS_FILE_NAME="$BACKUP_NAME-$NOW.zip"

# 上传(上传文件依赖ossutil)
echo "start upload"
ossutil64 cp $BACKUP_FILE oss://$OSS_BUCKET/$BACKUP_NAME/$OSS_FILE_NAME
echo "upload done"

# 删除备份文件
rm -rf $BACKUP_SRC