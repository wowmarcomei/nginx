FROM nginx:latest

# 安装必要的工具
RUN apt-get update && \
    apt-get install -y logrotate cron

# 创建logrotate配置文件
COPY logrotate.conf /etc/logrotate.d/nginx

# 添加cron任务以定期运行logrotate
RUN echo "*/1 * * * * root logrotate /etc/logrotate.d/nginx" > /etc/cron.d/logrotate

# 暴露端口
EXPOSE 80 443

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]
