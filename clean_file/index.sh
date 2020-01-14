#!/usr/bin/env bash

# 实现读取INI文件
function readINI () {
  Key=$1
  Section=$2 
  Config=$3
  RESULT=`awk -F ' = ' '/\['$Section'\]/{a=1}a==1&&$1~/'$Key'/{print $2;exit}' $Config`
  echo $RESULT
}

# 实现从INI从分割数组
function INIToArray () {
  # 保存原有的分隔符
  OLD_IFS="$IFS"
  # 自定义分隔符
  IFS=$2
  # 定义输出数组
  Arr=($1)
  # 恢复原有分隔符
  IFS="$OLD_IFS"
  # 这里不能直接输出整个数组，会出问题，应该把整个数组获取出来全部返回
  echo ${Arr[*]}
}

# 参数源
ConfigFile=$1config.ini

# 保留文件数
ReserveNum=$(readINI ReserveNum SYSTEM ${ConfigFile})

# 获取配置里的文件目录
FileDirMiddle=$(readINI FileDir SYSTEM ${ConfigFile})

# 获取配置里的文件正则匹配规则
FileRegMiddle=$(readINI FileReg SYSTEM ${ConfigFile})

# 通过INIToArray工具函数解析配置里的文件目录格式
# $1    是传入需要解析的字符串
# $2    间隔符
# 外面一定要加上()，重新把解析的字符串组成数组格式
FileDir=($(INIToArray ${FileDirMiddle} ,))

# 获取FileDir的长度
FileDirLen=${#FileDir[*]}

# 通过INIToArray工具函数解析配置里的文件正则表达式规则
# $1    是传入需要解析的字符串
# $2    间隔符
# 外面一定要加上()，重新把解析的字符串组成数组格式
FileReg=($(INIToArray ${FileRegMiddle} ,))

# 获取服务器的当前时间，用于删除数据时记录时间点
date=$(date "+%Y%m%d-%H%M%S")

#####	参数解析完毕

echo 参数解析完毕

#####	开始遍历文件目录数组清理数据

echo 开始遍历文件目录数组清理数据

# 双重循环删除目标文件
 
for ((i=0;i<$FileDirLen;i++))
do

  # 保存当前操作的文件目录
  FileTemp=${FileDir[$i]} 
  
  # 保存当前操作的文件匹配规则
  FileRegTemp=${FileReg[$i]}

  # 判断文件夹是否存在
  # 不存在则跳过进入下一次循环
  if [ ! -d ${FileTemp} ]; then
    echo ${FileTemp} 目录不存在, 跳过
    continue
  fi
  
  # 判断参数完整性
  if [ ! $FileTemp ] || [ ! $FileRegTemp ]; then
    echo 参数缺失, 终止匹配, 请检查配置文件
    break
  fi
  
  # 计算文件总数量
  FileNum=$(ls -l ${FileTemp} | grep -E ${FileRegTemp} | wc -l)
  
  # 无多余文件可清理
  if (($ReserveNum >= $FileNum)); then
    echo ${FileTemp} 无多余文件可清理, 跳过
    continue
  fi

  while(($FileNum > $ReserveNum))
  do
    OldFile=$(ls -rt $FileTemp | grep -E ${FileRegTemp} | head -1)
    echo $date Delete File: ${FileTemp}/${OldFile}
    rm -rf ${FileTemp}/${OldFile}
    let "FileNum--"
  done
done

echo 清理完毕
