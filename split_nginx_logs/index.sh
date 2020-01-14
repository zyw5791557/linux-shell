#!/bin/bash

# Rotate the nginx logs to prevent a single logfile from consuming too much disk space.

# 需要拆分的日志根目录
logs_path=/home/phjr/web-service/nginx/logs/

# 标准日志输出
logs_access_name=phjr_access.log

# 错误日志输出
logs_error_name=phjr_error.log

# 格式化当前时间
today=$(date +%Y-%m-%d)

# Ningx 进程号
nginx_pid=/home/phjr/web-service/nginx/logs/nginx.pid

# 拆分日志
mv ${logs_path}${logs_access_name} ${logs_path}${today}_${logs_access_name}
mv ${logs_path}${logs_error_name} ${logs_path}${today}_${logs_error_name}

# 向 Nginx 主进程发送 USR1 信号。USR1 信号会让程序重新打开日志文件
kill -USR1 $(cat ${nginx_pid})
