### 文件详情

|-- user_bat			# 用户家目录批处理
   |-- index.sh                 # 脚本主体
   |-- config.ini               # 脚本参数文件
   |-- user.txt			# 需要进行批处理的用户数据清单
   |-- output.log               # 脚本输入 (标准输出和错误输出)
   |-- start.sh                 # 脚本执行文件
   |-- expect-ssh.sh		# 通过 expect 自助交互式远程连接服务器(ssh)，并执行一些操作
   |-- README.md                # 脚本使用文档


### 注意点

1. 脚本执行修改权限问题
2. 脚本参数检查 `config.ini`,  `start.sh`, `user.txt`
3. 脚本应挂到用户`crontab`用户定时任务下执行
4. 在配置`config.ini`的时候, `=`两边一定要空格！！！

### 步骤(所有参数变量仅为实例使用，具体按实体部署脚本)

1. 修改配置文件  

- 修改配置文件 `config.ini`
- 修改脚本启动文件内部变量 `start.sh`
- 配置用户数据清单 `user.txt`


2. 脚本目录权限

- 修改脚本根目录的配置文件和日志读写权限，和脚本主体文件及启动脚本的执行权限


3. 通过脚本用户挂载定时任务

- 通过`crontab -e`编辑用户定时任务，`59 23 * * * sh /home/Emlice/sh/user_bat/start.sh` (每晚的23:59定时执行一次脚本任务)
- `crontab -l` 查看当前用户的定时任务
