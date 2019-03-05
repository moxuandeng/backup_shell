# 备份
备份Mysql数据与Gitea到阿里云oss，依赖ossutil上传文件

# ossutil
ossutil是以命令行方式管理OSS数据的工具，提供方便、简洁、丰富的Bucket和Object管理命令，支持Windows、Linux、 Mac平台。

[ossutil文档](https://help.aliyun.com/document_detail/50452.html)

ossutil配置

```sh
# 下载ossutil
wget http://gosspublic.alicdn.com/ossutil/1.4.2/ossutil64
# 移动
mv ossutil64 /usr/bin/ossutil64
# 修改文件执行权限
chmod +x /usr/bin/ossutil64
# 配置ossutil
ossutil64 config
```

# mysql

1. 修改**mysql.sh**中的配置信息
2. 添加到crontab

```sh
# 编辑crontab
crontab -e
# 输入: 0 3 * * * /<YOUR_PATH>/mysql.sh > /dev/null 2>&1
```

# gitea
备份docker中运行的gitea的数据

参考**https://docs.gitea.io/zh-cn/backup-and-restore/**

1. 修改**gitea.sh**中的配置信息
2. 添加到crontab



```sh
# 编辑crontab
crontab -e
# 输入: 0 2 * * * /<YOUR_PATH>/gitea.sh > /dev/null 2>&1
```