#!/bin/bash

# 脚本根目录
shell_dir=/home/Emlice/sh/process_monitoring/

sh ${shell_dir}index.sh ${shell_dir} > ${shell_dir}output.log 2>&1
