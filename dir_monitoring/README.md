### 文件详情

|-- dir_monitoring
   |-- index.sh			# 脚本主体
   |-- config.ini		# 脚本参数文件
   |-- output.log		# 脚本输入 (标准输出和错误输出)
   |-- start.sh			# 脚本执行文件
   |-- full_monitoring.log	# 资源监控下所有目录的使用情况
   |-- limit_monitoring.log	# 资源控制下超过限制目录的使用情况
   |-- README.md		# 脚本使用文档


### 注意点

1. 脚本执行修改权限问题
2. 脚本参数检查 `config.ini`,  `start.sh`
3. 脚本应挂到用户`crontab`用户定时任务下执行
4. 在配置`config.ini`的时候, `=`两边一定要空格！！！

### 权限问题的分析

1. 用户家目录的权限是700
2. 使用`shadmin`用户挂脚本，这个用户必须具有`sudo`执行`du`命令的权限
3. 配置`/etc/sudoers`为`shadmin ALL=(root) NOPASSWD: /usr/bin/du`赋予用户以root执行du命令的权限切无需密码验证
4. 脚本目录需修改权限，以可以读写配置和日志


### 备用方案

1. 脚本密码交互式验证问题，若配置`sudoers`失败可以采用`expect`


### 步骤(所有参数变量仅为实例使用，具体按实体部署脚本)

1. 修改配置文件  

- 修改配置文件`config.ini`
- 修改脚本启动文件内部变量 `start.sh`


2. 创建脚本执行用户

- 通过root创建脚本执行用户`shadmin`，并通过`/etc/sudoers`赋权`shadmin ALL=(root) NOPASSWD: /usr/bin/du`(获取以root执行du命令的权限，且无需密码验证)


3. 脚本目录权限

- 修改脚本根目录的配置文件和日志读写权限，和脚本主体文件及启动脚本的执行权限


4. 通过脚本用户挂载定时任务

- 通过`crontab -e`编辑用户定时任务，`59 23 * * * sh /work/dir_monitoring/start.sh` (每晚的23:59定时执行一次脚本任务)
- `crontab -l` 查看当前用户的定时任务



