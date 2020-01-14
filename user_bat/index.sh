#!/bin/env bash

############# 工具函数

# 实现读取INI文件
function readINI () {
  Key=$1
  Section=$2
  Config=$3
  RESULT=`awk -F ' = ' '/\['$Section'\]/{a=1}a==1&&$1~/'$Key'/{print $2;exit}' $Config`
  echo $RESULT
}

############# 获取参数

# 参数源
config_file=$1config.ini

# 远程服务器的IP地址
server_ip=$(readINI server_ip SYSTEM ${config_file})

# known_hosts 内容
known_content=$(readINI known_content SYSTEM ${config_file})

############# 脚本主体

# 保存默认分隔符并修改为回车符
OLD_IFS=$IFS
IFS=$'\n'

# 循环遍历用户数据
for item in `cat $1/user.txt`; do

# 处理行数据获取用户信息
user=$(echo $item | awk '{print $1}')
email=$(echo $item | awk '{print $2}')
password=$(echo $item | awk '{print $3}')

# 使用 expect 进行自助交互式操作 | ssh 远程接入
$1/expect-ssh.sh $user $server_ip $password $email $known_content

done

# 恢复默认分隔符
IFS=$OLD_IFS


