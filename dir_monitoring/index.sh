#!/bin/bash

############# 工具函数

# 实现读取INI文件
function readINI () {
  Key=$1
  Section=$2
  Config=$3
  RESULT=`awk -F '=' '/\['$Section'\]/{a=1}a==1&&$1~/'$Key'/{print $2;exit}' $Config`
  echo $RESULT
}

############ 参数加载

# 参数源
ConfigFile=$1

# 监控目录
monitoring_dir=$(readINI monitoring_dir DIR ${ConfigFile})

# 日志输出目录
output_dir=$(readINI output_dir DIR ${ConfigFile})

# 完整的资源目录监控日志
full_monitoring_log=${output_dir}$(readINI full_monitoring_name LOG ${ConfigFile})

# 超过限制的资源目录监控日志
limit_monitoring_log=${output_dir}$(readINI limit_monitoring_name LOG ${ConfigFile})

# 默认的目录大小限制若改变单位需修改下面的 du 命令的参数
normal_size_limit=$(readINI normal SIZE_LIMIT ${ConfigFile})

# 目录大小限制的单位
size_unit=$(readINI size_unit SYSTEM ${ConfigFile})

############ 日志清理

> $full_monitoring_log
> $limit_monitoring_log

############ 脚本主体

echo 目录监控资源限制的单位为：$size_unit

echo 目录总大小为：$(sudo du -sh${size_unit} ${monitoring_dir} | cut -f 1)

# 若改变单位需要修改这里的 size_unit 参数
dir_size=($(sudo du -sh${size_unit} ${monitoring_dir}* | sort -nr | cut -f 1 | xargs))

# 获取目录
dir_name_middle=($(sudo du -sh${size_unit} ${monitoring_dir}* | sort -nr | cut -f 2 | xargs))

echo 资源监控情况如下：

for (( i=0;i<${#dir_name_middle[*]};i++ ))
do

# 字符串截取 | 获取当前文件夹名称
dir_name=${dir_name_middle[$i]#*${monitoring_dir}}

# 从参数源里获取用户单独的目录限制 | 若没有配置则为空
user_limit=$(readINI ${dir_name} SIZE_LIMIT ${ConfigFile})
# 用三元表达式计算真实的用户目录限制
size_limit=$((user_limit ? user_limit : normal_size_limit))

echo ${dir_name}:${dir_size[$i]}:$size_limit >> $full_monitoring_log
echo ${dir_name}:${dir_size[$i]}:$size_limit

# 判断是否超过限制
if (( ${dir_size[$i]} > $size_limit )); then
  echo ${dir_name}:${dir_size[$i]}:$size_limit >> $limit_monitoring_log
fi

done

# 打印当前脚本执行时间
echo $(date)
