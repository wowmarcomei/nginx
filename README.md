这个仓库主要用于使用最新的Nginx Docker镜像，编译一个新的镜像，在镜像中加入了logrotate与cron工具，创建了一个cron 任务，每天凌晨 0 点以root身份执行任务`RUN echo "0 0 * * * root logrotate /etc/logrotate.d/nginx" > /etc/cron.d/logrotate`.

其中的logrotate任务为：
```shell
/var/log/nginx/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        /usr/sbin/nginx -s reload
    endscript
}
```
即，对nginx容器中的/var/log/nginx/*.log进行轮换：
- `/path/to/your/app/logs/*.log`: nginx日志文件的实际路径。
- daily: 每天轮换日志。
- rotate 7: 保留 7 个轮换日志文件。
- missingok: 如果日志文件不存在，则不报错。
- notifempty: 如果日志文件为空，则不轮换。
- compress: 使用 gzip 压缩旧日志文件。
- delaycompress: 压缩前一天的日志文件，而不是当前的日志文件。
- copytruncate: 创建日志文件的副本，然后清空原始文件。这可以防止日志记录过程中出现数据丢失。
- postrotate： `/usr/sbin/nginx -s reload`，重启nginx服务。
