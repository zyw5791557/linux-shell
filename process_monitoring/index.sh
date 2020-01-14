#!/bin/bash

############# 工具函数

# 实现读取INI文件
function readINI () {
  Key=$1
  Section=$2
  Config=$3
  RESULT=`awk -F ' = ' '/\['$Section'\]/{a=1}a==1&&$1~/'$Key'/{print $2;exit}' $Config`
  echo $RESULT
}

######### 获取参数

# 参数源
config_file=$1config.ini

# 获取主机名
hostname=$(hostname)

# 日志输出目录
output_dir=$(readINI output_dir DIR ${config_file})

# 进程监控输出文件 | 拼接上主机名
filter_log=$(readINI filter_log LOG ${config_file})-${hostname}.log

# 进程用户名最大显示长度
process_user_length=$(readINI process_user_length SYSTEM ${config_file})

# 进程用户名占位符 | x
process_user_placeholder=''

# 转换为真实长度的占位符
for ((i=0;i<$process_user_length;i++)); do
process_user_placeholder=${process_user_placeholder}x
done

# 需要监控的进程关键字
process_key=$(readINI process_key SYSTEM ${config_file})

# 最大运行时间 | 过滤 | $(()) 数值运算
max_runtime=$(( $(readINI max_runtime SIZE_LIMIT ${config_file}) ))

# 获取 ps 可显示的最大列数
ps_columns=$(readINI ps_columns SYSTEM ${config_file})

######### 清空日志

> $filter_log

######### 主体 | 查找进程，过滤并输出

# 打印一行标题到日志中

# 命令解析
# ps 瞬时进程状态查看命令
# -e 显示所有进程 -o 定制字段和格式
# --sort=[fields] 表示排序 (这里只能使用ps 自带的排序方式去对运行时间进行排序, 不能使用 sort 命令会有问题)
# pid 进程号
# etimes 进程运行的时间(单位是秒)
# cmd 完整命令行信息

ps -eo user,pid,etimes,cmd | head -1 >> $filter_log

# 查找目标进程并进行条件过滤输出到日志中

# 命令解析
# grep 进行文本关键字过滤
# -v 过滤有这个字符串的

# awk 强大的文本数据处理和分析的命令
# 这里做的处理是取每一行的第三个变量(默认按空格分隔)大于等于限制的运行时间为条件过滤输出
# 这里要是觉得shell过长可以通过'\'分行
# grep -E 正则匹配过滤

ps -o user=${process_user_placeholder} --sort=etime -eo pid,etimes,cmd --columns ${ps_columns} | grep -E $process_key | grep -v grep | awk '$3 >= '${max_runtime} >> $filter_log




